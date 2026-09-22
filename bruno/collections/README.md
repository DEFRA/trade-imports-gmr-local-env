# trade-imports-gmr

Bruno collection for exploring Trade Imports GMR services locally and on CDP.

- [trade-imports-gmr-finder](https://github.com/DEFRA/trade-imports-gmr-finder)
- [trade-imports-gmr-processor](https://github.com/DEFRA/trade-imports-gmr-processor)

## Prerequisites

### Dependencies

Install the following:

- [Bruno](https://www.usebruno.com/)

### Configuration

Configure the Bruno collection via `Collection > Configure` (top right of Bruno application) as follows:

| Secret                  | Notes                                                                                                                                                                                        |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `basic_auth_password`   | Must be set to `test` locally. For username and password combinations on CDP see the CDP terminal on the given environment.                                                                  |
| `cdp_developer_api_key` | Not required locally, must be set to your developer API key for any given CDP environment, see [instructions](https://portal.cdp-int.defra.cloud/documentation/how-to/developer-api-key.md). |

## Usage

Open the collection in Bruno, select an environment, execute requests.

Modify `customs-declaration.json` and/or `import-pre-notification.json` if necessary.
