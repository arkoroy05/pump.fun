import { ethers } from "ethers"

function Token({ toggleTrade, token }) {
  return (
    <button onClick={() => toggleTrade(token)} className="token">

    </button>
  );
}

export default Token;