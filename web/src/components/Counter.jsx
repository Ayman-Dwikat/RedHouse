import React, { useState, useEffect } from 'react';

function Counter({ target }) {
  const [count, setCount] = useState(0);

  useEffect(() => {
    if (count < target) {
      const interval = setInterval(() => {
        setCount((prevCount) => prevCount + 1);
      }, 10); // 3000 milliseconds = 3 seconds

      return () => clearInterval(interval);
    }
  }, [count, target]);

  return (
    <div>
      <p>{count}</p>
    </div>
  );
}
export default Counter