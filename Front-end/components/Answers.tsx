import * as React from 'react';
import { Box, Center, Spinner, Stack } from '@chakra-ui/react';
import useAnswers from '../hooks/useAnswers';
import Answer from './Answer';
import type { BigNumber } from 'ethers';
import type { Answer as AnswerStruct } from '../hooks/contracts/useForumContract';
// import toast from 'react-hot-toast';
// import useTokenContract from '../hooks/useTokenContract';
// import useEvents from '../hooks/useEvents';

interface AnswersProps {
  questionId: BigNumber;
}

const Answers: React.FunctionComponent<AnswersProps> = ({ questionId }) => {
  const [sortedAnswers, setSortedAnswers] = React.useState<AnswerStruct[]>([]);
  const answersQuery = useAnswers({ questionId });
  // const [isLoading, setIsLoading] = React.useState(false);
  // const tokenContract = useTokenContract();
  // useEvents({ questionId });

  React.useEffect(() => {
    if (answersQuery.data) {
      const sortAnswers = answersQuery.data.sort((a, b) => (a.upvotes > b.upvotes ? -1 : 1));
      setSortedAnswers(sortAnswers);
    }
  }, [answersQuery.data, answersQuery.isFetched]);

  const handleClick = async () => {
    // try {
    //   setIsLoading(true);
    //   await tokenContract.mint(ethers.utils.parseUnits('10'));
    //   toast.success(`Minted 10 tokens for you :) Make sure to import the GOFLOW token address`);
    //   setIsLoading(false);
    // } catch (e) {
    //   toast.error(e.message); // if you're getting a 'Nonce too high' error you need to reset your metamask account on localhost only
    //   console.log(e);
    // }
  };

  return (
    <Box>
      {answersQuery.isLoading && (
        <Center p={8}>
          <Spinner />
        </Center>
      )}
      <Stack spacing={2}>
        {sortedAnswers?.map((answer, i) => (
          <Answer key={answer.answerId.toNumber()} answer={answer} first={i === 0 && answer.upvotes.toNumber() != 0} />
        ))}
        {/* {answersQuery.isFetched ? <CommentEditor questionid={questionId} clickHandler={handleClick} /> : null} */}
      </Stack>
    </Box>
  );
};

export default Answers;
