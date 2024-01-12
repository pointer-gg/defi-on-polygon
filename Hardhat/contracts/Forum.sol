//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

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

  event QuestionAdded(Question question);
  event AnswerAdded(Answer answer);

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

  function getQuestions() external view returns (Question[] memory) {
    return questions;
  }

  function getAnswersPerQuestion(uint _questionId) public view returns (uint[] memory) {
    return answersPerQuestion[_questionId];
  }
}