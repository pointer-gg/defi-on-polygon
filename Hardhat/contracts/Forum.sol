//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Forum {
  struct Question {
    uint questionId;
    string message;
    address creatorAddress;
    uint timestamp;
  }

  struct Answer {
    uint answerId;
    uint questionId;
    address creatorAddress;
    string message;
    uint timestamp;
    uint upvotes;
  }

  Question[] public questions;
  Answer[] public answers;
  mapping (uint => uint[]) public answersPerQuestion;

  mapping (uint => mapping(address => bool)) public upvoters;
  mapping (address => uint) public usersUpvoteCount;

  event QuestionAdded(Question question);
  event AnswerAdded(Answer answer);
  event AnswerUpvoted(Answer answer);

  IERC20 public immutable Goflow;
  // Internal variable for helping with token math
  uint constant decimals = 18;

  uint amountToPay = 1 * 10**decimals;
  uint amountToParticipate = 10 * 10**decimals;

  constructor(address _tokenAddress) {
    Goflow = IERC20(_tokenAddress);
  }

  modifier answerExists(uint _answerId) {
    require(answers.length >= _answerId, 'Answer does not exist!');
    _;
  }

  function postQuestion(string calldata _message) external {
    uint questionCounter = questions.length;
    Question memory question = Question({
      questionId: questionCounter,
      message: _message,
      creatorAddress: msg.sender,
      timestamp: block.timestamp
    });
    questions.push(question);
    emit QuestionAdded(question);
  }

  function postAnswer(uint _questionId, string calldata _message) external {
    uint answerCounter = answers.length;
    Answer memory answer = Answer({
      answerId: answerCounter,
      questionId: _questionId,
      creatorAddress: msg.sender,
      message: _message,
      timestamp: block.timestamp,
      upvotes: 0
    });
	// we use an answer array and an answersPerQuestion mapping to store answerIds for each question.
	// This makes it easier for us to fetch the answers based on a questionId
    answers.push(answer);
    answersPerQuestion[_questionId].push(answerCounter);
    emit AnswerAdded(answer);
  }

  function upvoteAnswer(uint _answerId) external answerExists(_answerId) {
    require(answers.length >= _answerId, "Answer does not exist");

    require(upvoters[_answerId][msg.sender] != true, 'User already upvoted this answer!');
    require(answers[_answerId].creatorAddress != msg.sender, 'Cannot upvote own answer!');
    require(Goflow.balanceOf(msg.sender) >= amountToPay, 'User has insufficient balance!');
    require(Goflow.allowance(msg.sender, address(this)) >= amountToPay, 'Account did not approve token succesfully!');
    
    Answer storage currentAnswer = answers[_answerId]; 
      
    bool sent;
    if (Goflow.balanceOf(currentAnswer.creatorAddress) >= 10) {
      sent = Goflow.transferFrom(msg.sender, currentAnswer.creatorAddress, 1); 
    } else {
      sent = Goflow.transferFrom(msg.sender, address(this), amountToPay); 
    }
    
    require(sent, "Token transfer failed!");
    currentAnswer.upvotes++;
    usersUpvoteCount[msg.sender] += 1;
    upvoters[_answerId][msg.sender] = true;

    emit AnswerUpvoted(currentAnswer);
  }

  function getQuestions() external view returns (Question[] memory) {
    return questions;
  }

  function getAnswersPerQuestion(uint _questionId) public view returns (uint[] memory) {
    return answersPerQuestion[_questionId];
  }

  function getUpvotes(uint _answerId) public view answerExists(_answerId) returns (uint) {
    return answers[_answerId].upvotes;
  }
}