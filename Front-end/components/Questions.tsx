import * as React from 'react';
import { Box, Center, Spinner, Stack } from '@chakra-ui/react';
import useQuestions from '../hooks/useQuestions';
import Question from './Question';

const Questions: React.FunctionComponent = () => {
  const { allQuestionsQuery } = useQuestions({});

  return (
    <Box>
      {allQuestionsQuery.isLoading && (
        <Center p={8}>
          <Spinner />
        </Center>
      )}
      <Stack spacing={4}>
        {allQuestionsQuery.data?.map((q) => (
          <Question {...q} key={q.questionId.toNumber()} />
        ))}
      </Stack>
    </Box>
  );
};

export default Questions;
