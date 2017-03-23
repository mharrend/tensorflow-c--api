pipeline {
  agent {
    node {
      label 'slc6'
    }
    
  }
  stages {
    stage('Preparation') {
      steps {
        echo 'Start with preparations'
        mattermostSend(message: 'Tensorflow-C++-API build start', channel: 'ttHGroup-devel', icon: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png?version=1&modificationDate=1302753947000')
      }
    }
    stage('Start script') {
      steps {
        echo 'Start script'
        node(label: 'slc6') {
          sh '''#!/bin/zsh -l
# Use login shell
set -o xtrace
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch 
source $VO_CMS_SW_DIR/cmsset_default.sh
# setup environment
export SCRAM_ARCH="slc6_amd64_gcc530"
export CMSSW_VERSION="CMSSW_8_0_26_patch1"
# Variables
export JENKINSCMSSWFOLDER=$CMSSW_VERSION
echo $JENKINSCMSSWFOLDER
export JENKINSCMSSWINSTALLDIR=$PWD"/"$JENKINSCMSSWFOLDER
echo $JENKINSCMSSWINSTALLDIR
export JENKINSCMSSWSRCDIR=$JENKINSCMSSWINSTALLDIR"/src"
echo $JENKINSCMSSWSRCDIR


# create new CMSSW environment
scram project $JENKINSCMSSWFOLDER
cd $JENKINSCMSSWSRCDIR
eval `scramv1 runtime -sh` 

# Compiling bazel
echo "Start compiling bazel"

wget https://github.com/bazelbuild/bazel/archive/0.4.5.tar.gz
tar xvf 0.4.5.tar.gz
chmod +x ./bazel-0.4.5/compile.sh
./bazel-0.4.5/compile.sh --help
./bazel-0.4.5/compile.sh





'''
        }
        
      }
    }
    stage('Deploy') {
      steps {
        echo 'Finishing...'
        mattermostSend(message: 'Tensorflow-C++-API build start', channel: 'ttHGroup-devel', color: 'green')
      }
    }
  }
}