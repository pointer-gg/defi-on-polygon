import * as React from 'react';
import { useEffect } from 'react';
import { Icon } from '@chakra-ui/react';
import { FaArrowUp } from 'react-icons/fa';
import { Button, ButtonProps, Text } from '@chakra-ui/react';
import { useAccount } from 'wagmi';
import useForumContract from '../hooks/contracts/useForumContract';
import useUpvotes from '../hooks/useUpvotes';
import type { BigNumber } from 'ethers';
import { ethers } from 'ethers';
// import { makeBig } from '../lib/number-utils';
// import useTokenContract from '../hooks/useTokenContract';
// import toast from 'react-hot-toast';
// import useAddUpvote from '../hooks/useAddUpvote';

interface UpvoteButtonProps extends ButtonProps {
  answerId: BigNumber;
}

const Upvote: React.FunctionComponent<UpvoteButtonProps> = ({ answerId, ...props }) => {
  const [upvoteCount, setUpvoteCount] = React.useState(0);
  const [isLoading, setIsLoading] = React.useState(false);
  const { address: account } = useAccount();

  const forumContract = useForumContract();
  // const token = useTokenContract();

  const upvotesQuery = useUpvotes({ answerId });
  // const addUpvoteAndMutate = useAddUpvote();

  const upvoteCountText = upvoteCount === 1 ? '1 Upvote' : `${upvoteCount} Upvotes`;

  useEffect(() => {
    const fetchUpvoteCount = async () => {
      if (upvotesQuery.isFetched && !!upvotesQuery.data) {
        setUpvoteCount(upvotesQuery.data?.toNumber());
      }
    };
    fetchUpvoteCount();
  }, [answerId, upvotesQuery.data, upvotesQuery.isFetched]);

  const handleClick = async () => {
    // try {
    //   setIsLoading(true);
    //   await token.approve(upvotesContract.contract.address, makeBig(1));
    //   await addUpvoteAndMutate.mutateAsync({ answerId });
    //   setIsLoading(false);
    //   toast.success(`Upvoted!`);
    // } catch (e) {
    //   toast.error(e.data?.message || e.message);
    //   setIsLoading(false);
    // }
  };

  return (
    <>
      <Text fontSize='sm' color='gray.500' mx={3}>
        {upvoteCountText}
      </Text>
      <Button {...props} isLoading={isLoading} disabled={!account} onClick={handleClick}>
        <Icon as={FaArrowUp} />
      </Button>
    </>
  );
};

export default Upvote;
