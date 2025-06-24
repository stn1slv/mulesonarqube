# SonarQube for Mule

A Docker-based SonarQube setup with the Mule validation plugin for static code analysis of MuleSoft applications.

## Overview

This project provides a containerized SonarQube instance pre-configured with the MuleSoft validation plugin, enabling comprehensive static code analysis for both Mule 3 and Mule 4 applications. It includes custom rule sets that enforce MuleSoft best practices and coding standards.

## Features

- **SonarQube 9.9 Community Edition** with Mule plugin pre-installed
- **Multi-version support** for both Mule 3 and Mule 4 applications
- **Custom rule sets** covering:
  - Application structure and configuration
  - Flow and sub-flow best practices
  - Security and vulnerability checks
  - Code quality and maintainability standards
- **Docker Compose** setup for easy deployment
- **Pre-configured authentication** disabled for development environments

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- MuleSoft application projects to analyze

### Option 1: Using Docker Compose (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/stn1slv/mulesonarqube.git
   cd mulesonarqube
   ```

2. Start SonarQube using Docker Compose:
   ```bash
   docker-compose up
   ```

3. Access SonarQube at `http://localhost:9000`

### Option 2: Using Docker Run

If you prefer to use Docker directly without Docker Compose:

```bash
docker run \
  --name mulesonarqube \
  -p 9000:9000 \
  -v ./config-files:/opt/sonarqube/config-files \
  stn1slv/sonarqube-for-mule:9.9
```

Access SonarQube at `http://localhost:9000`

### Option 3: Building from Source

If you want to build the image yourself:

1. Clone this repository:
   ```bash
   git clone https://github.com/stn1slv/mulesonarqube.git
   cd mulesonarqube
   ```

2. Build the custom SonarQube image:
   ```bash
   docker build -t mulesonarqube:latest .
   ```

3. Run the container:
   ```bash
   docker run \
     --name mulesonarqube \
     -p 9000:9000 \
     -v ./config-files:/opt/sonarqube/config-files \
     mulesonarqube:latest
   ```

4. Access SonarQube at `http://localhost:9000`

### Analyzing Your Mule Project

1. Install SonarQube Scanner in your project or use the Maven plugin
2. Get SonarQube token:
   ```bash
   curl -s -X POST -u admin:admin "http://localhost:9000/api/user_tokens/generate" \
      -d "name=auto-token-$(date +%s)" \
      -d "login=admin" | \
      grep -o '"token":"[^"]*"' | cut -d'"' -f4
   ```
3. Run the analysis:
   ```bash
   mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 \ 
         -Dsonar.sources=src/main/mule \ 
         -Dsonar.mule.file.suffixes=xml \  
         -Dsonar.xml.file.suffixes=xsd,xsl \
         -Dsonar.login=<SONARQUBE_TOKEN>
   ```

## Rule Sets

> **Note:** The included rule files (`rules-3.xml` and `rules-4.xml`) are provided as examples to demonstrate the plugin's capabilities. Users should customize these rules according to their specific project requirements, coding standards, and organizational best practices. You can modify the existing rules or create entirely new rule sets while maintaining the same filenames.

### Mule 3 Rules (`rules-3.xml`)

**Application Rules:**
- APIKit configuration validation
- Global exception strategy requirements

**Flow Rules:**
- Flow count limitations (max 10 per file)
- Sub-flow count limitations (max 5 per file)
- Naming convention enforcement
- Security checks for encryption keys

**Configuration Rules:**
- Property management validation
- Security configuration checks
- HTTP protocol enforcement (HTTPS)
- Data transformation best practices

### Mule 4 Rules (`rules-4.xml`)

**Application Rules:**
- APIKit configuration validation
- Error handling strategy requirements

**Flow Rules:**
- Flow and sub-flow count limitations
- Naming convention enforcement
- Security vulnerability checks

**Configuration Rules:**
- Secure properties configuration
- API Gateway autodiscovery validation
- HTTP/HTTPS configuration checks
- Database connection security
- Domain-specific rules for shared configurations

## Rule Categories

- **🔧 Code Smell**: Maintainability and code quality issues
- **🐛 Bug**: Potential runtime issues and errors
- **🔒 Vulnerability**: Security-related concerns
- **⚠️ Major/Minor/Critical**: Severity levels for prioritization

## Customization

### Adding Custom Rules

1. Edit the rule files in `config-files/`:
   - `rules-3.xml` for Mule 3 specific rules
   - `rules-4.xml` for Mule 4 specific rules

2. Restart the container to apply changes:
   ```bash
   docker-compose restart
   ```

### Rule Structure

```xml
<rule id="unique-id" 
      name="Rule Name" 
      description="Rule Description" 
      severity="MAJOR|MINOR|CRITICAL" 
      type="code_smell|bug|vulnerability">
    XPath expression for validation
</rule>
```

## Configuration

### Environment Variables

- `SONAR_SECURITY_FORCE_AUTHENTICATION=false` - Disables authentication
- `SONAR_FORCEAUTHENTICATION=false` - Additional authentication bypass

### Volumes

- Rule files are mounted from `./config-files/` to `/opt/sonarqube/extensions/plugins/`
- SonarQube data, configuration, and logs are persisted in Docker volumes

## Building Custom Image

To build your own image with modifications:

```bash
docker build -t your-sonarqube-mule:tag .
```

Update the `docker-compose.yml` to use your custom image or use it directly with docker run.

## Troubleshooting

### Common Issues

1. **Container fails to start**: Check Docker logs and ensure sufficient memory allocation
2. **Rules not applied**: Verify rule files are properly mounted and XML is valid
3. **Analysis fails**: Ensure SonarQube Scanner is properly configured for Mule projects

### Logs

Access SonarQube logs:
```bash
docker-compose logs sonarqube
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or modify rules in the appropriate XML files
4. Test your changes
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- [SonarQube Documentation](https://docs.sonarqube.org/)
- [MuleSoft Best Practices](https://docs.mulesoft.com/general/best-practices)
- [Mule SonarQube Plugin](https://github.com/mulesoft-catalyst/mule-sonarqube-plugin)