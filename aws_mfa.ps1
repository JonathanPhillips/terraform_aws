# Select a profile for MFA
$profiles = @("prod", "dev, "qa")
$profileIndex = $host.UI.PromptForChoice("Select a profile for MFA", "Please choose:", $profiles, 0)
$sourceProfile = $profiles[$profileIndex]

# Set the profile you want to use for MFA, appending the selected profile
$mfaProfile = "mfa-$sourceProfile"

# Read the MFA device ARN from the credentials file
$mfaDeviceArn = aws configure get mfa_device_arn --profile $sourceProfile
if ([string]::IsNullOrEmpty($mfaDeviceArn)) {
    Write-Host "Error: MFA device ARN not found in the ~/.aws/credentials file for profile $sourceProfile"
    exit
}

# Enter your MFA token code
$mfaCode = Read-Host "Enter your MFA token code"

# Get the temporary credentials
$credentialsJson = aws sts get-session-token --serial-number $mfaDeviceArn --token-code $mfaCode --profile $sourceProfile --output json
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to obtain temporary credentials. Please check your MFA token code and try again."
    exit
}

# Convert JSON response to an object
$credentials = $credentialsJson | ConvertFrom-Json

# Check if the credentials are not empty
if ([string]::IsNullOrEmpty($credentials.Credentials.AccessKeyId) -or
    [string]::IsNullOrEmpty($credentials.Credentials.SecretAccessKey) -or
    [string]::IsNullOrEmpty($credentials.Credentials.SessionToken)) {
    Write-Host "Error: Failed to parse temporary credentials. Please try again."
    exit
}

# Store the temporary credentials in the appropriate mfa profile
aws configure set aws_access_key_id $credentials.Credentials.AccessKeyId --profile $mfaProfile
aws configure set aws_secret_access_key $credentials.Credentials.SecretAccessKey --profile $mfaProfile
aws configure set aws_session_token $credentials.Credentials.SessionToken --profile $mfaProfile

Write-Host "Temporary credentials have been set for the '$mfaProfile' profile. They will expire on $($credentials.Credentials.Expiration)."
