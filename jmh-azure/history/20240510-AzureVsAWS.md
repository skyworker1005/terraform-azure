
# azure service principal 에 대응되는 aws는?
GPT
Azure의 서비스 주체에 해당하는 AWS의 개념은 IAM (Identity and Access Management) 역할입니다. AWS IAM 역할은 Azure 서비스 주체와 비슷한 기능을 제공하며, 애플리케이션이나 서비스가 특정 AWS 리소스에 액세스할 수 있도록 권한을 부여하는 데 사용됩니다.

주요 유사점과 차이점:
1. 액세스 권한:
- Azure 서비스 주체: 특정 리소스에 대해 세밀한 권한을 부여하는 Azure Active Directory (AAD) 객체입니다. 주로 애플리케이션, 스크립트 또는 자동화된 도구를 인증하는 데 사용됩니다.
- AWS IAM 역할: 역할을 가진 엔터티가 AWS API 및 서비스에 액세스하도록 허용하는 정책을 정의합니다. 사용자는 직접 로그인할 수 없지만, 역할을 수임하여 작업을 수행할 수 있습니다.
2. 정책 적용:
- Azure: 역할 기반 액세스 제어 (RBAC)를 통해 서비스 주체에 권한을 할당합니다.
- AWS: IAM 정책을 역할에 연결하여 권한을 부여합니다.
3. 사용 사례:
- Azure: Terraform, Ansible 등의 인프라 관리 도구를 통해 리소스를 관리하거나, 앱/서비스를 실행하는 데 사용됩니다.
- AWS: EC2 인스턴스 프로파일, Lambda 함수, ECS 태스크 등이 역할을 수임하여 필요한 작업을 수행합니다.

AWS에서 IAM 역할을 사용하면, 특정 리소스에 대한 액세스 및 제어를 세밀하게 관리할 수 있습니다.