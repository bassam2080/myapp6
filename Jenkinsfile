 pipeline {
  agent any

  environment {
    DOCKERHUB = credentials('DockerHub')         // Exposes DOCKERHUB_USR / DOCKERHUB_PSW
    SERVICE = 'web'                              // <-- match this to your compose service name
    REPORT_IN_CONTAINER = '/var/www/html/tests/report.xml'
    REPORT_LOCAL = 'report.xml'
  }

  stages {
    stage('Docker Login') {
      steps {
        sh 'echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USR" --password-stdin'
      }
    }

    stage('Pull , build and Run dockerfile ') {
      steps {
       

          docker stop myapp6 || true
		        docker rm myapp6 || true
		        docker rmi bassam2080/myapp6 || true
		        docker build -t bassam2080/myapp6:1.1 
        
        '''
      }
    }

    stage('Start Services or Run docker compose') {
      steps {
        // Bring up the stack fresh
        sh 'docker compose up -d'
      }
    }

    stage('Install Composer & PHPUnit') {
      steps {
        // Ensure composer exists in the container, then install deps + phpunit
        sh '''
          docker compose exec -T "$SERVICE" sh -lc 'command -v composer >/dev/null 2>&1 || (curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer)'
          docker compose exec -T "$SERVICE" php /usr/local/bin/composer --version
          docker compose exec -T "$SERVICE" php /usr/local/bin/composer install --no-interaction
          docker compose exec -T "$SERVICE" php /usr/local/bin/composer require --dev phpunit/phpunit --no-interaction
        '''
      }
    }

    stage('Run Tests') {
      steps {
        sh '''
          docker compose exec -T "$SERVICE" php ./vendor/bin/phpunit --log-junit "$REPORT_IN_CONTAINER"
          docker compose cp "$SERVICE:$REPORT_IN_CONTAINER" "$REPORT_LOCAL"
        '''
      }
    }

    stage('Publish Test Results') {
      steps {
        junit 'report.xml'
      }
    }
  }

  post {
    always {
      // Optional cleanup
      sh 'docker compose down || true'
      sh 'docker logout || true'
    }
  }
}
