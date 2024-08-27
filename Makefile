deploy-testnet:
	op run --env-file="./.env" -- \
  bash -c 'echo $$TESTNET_PK | xargs -I {} forge script DeployPermit2 --private-key {} -f ronin-testnet'

deploy-testnet-broadcast:
	op run --env-file="./.env" -- \
  bash -c 'echo $$TESTNET_PK | xargs -I {} forge script DeployPermit2 --private-key {} -f ronin-testnet --verify --verifier sourcify --verifier-url https://sourcify.roninchain.com/server/ --legacy --broadcast'

deploy-mainnet:
	op run --env-file="./.env" -- \
	bash -c 'echo $$MAINNET_PK | xargs -I {} forge script DeployPermit2 --private-key {} -f ronin-mainnet'

deploy-mainnet-broadcast:
	op run --env-file="./.env" -- \
	bash -c 'echo $$MAINNET_PK | xargs -I {} forge script DeployPermit2 --private-key {} -f ronin-mainnet --legacy --broadcast'
