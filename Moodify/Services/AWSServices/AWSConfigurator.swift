

import AWSCore

final class AWSConfigurator {

    static func configure() {
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast1,
            identityPoolId: "us-east-1:0874698f-d45e-41cb-a8ab-508eb2731f6a"
        )

        let configuration = AWSServiceConfiguration(
            region: .USEast1,
            credentialsProvider: credentialsProvider
        )

        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
}
