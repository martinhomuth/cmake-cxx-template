pipeline {
    options {
        buildDiscarder(logRotator(numToKeepStr: '4'))
    }
    agent {
        dockerfile {
            filename 'Dockerfile'
            dir 'ci'
        }
    }
    stages {
        stage('Setup Debug') {
            steps {
                sh '''
                cmake \
                  -B build  \
                  -DWARNINGS_AS_ERRORS=OFF \
                  -DENABLE_CODE_COVERAGE=ON \
                  -DCMAKE_BUILD_TYPE=Debug
                '''
            }
        }
        stage('Build Debug') {
            steps {
                sh 'make -C build'
                sh 'make -C build doc'
            }
        }
        stage('Test') {
            steps {
                sh '''
                # check tidy
                make -C build tidy
                # check format
                make -C build format
                git diff > clang-format.diff
                if [ -s clang-format.diff ]; then
                    echo "Error: clang-format created output"
                    cat clang-format.diff
                    exit 1
                fi
                # unit tests
                cd build
                ctest --output-on-failure -O test/result.log || exit 1
                cd ..
                # coverage
                cd build
                make coverage
                bash ../ci/coverage-report.sh ./coverage/index.html | tee ./coverage/lastCoverageValues.txt
                cd ..
                '''
            }
        }
        stage('Deploy') {
            steps {
                archiveArtifacts 'build/doc/**, build/test/**, build/coverage/**'
            }
        }
	stage('Setup Release') {
            steps {
                sh '''
                # cleanup
                make -C build clean
                cmake \
                  -B build  \
                  -DCMAKE_BUILD_TYPE=Release
                '''
            }
	}
        stage('Build Release') {
            steps {
                sh 'make -C build'
            }
        }
    }
}
