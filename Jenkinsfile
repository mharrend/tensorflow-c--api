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


# create new CMSSW environment and delete old one
echo "Deleting old CMSSW install dir: " $JENKINSCMSSWINSTALLDIR
rm -rf $JENKINSCMSSWINSTALLDIR
echo "Creating new CMSSW install dir"
scram project $JENKINSCMSSWFOLDER
cd $JENKINSCMSSWSRCDIR
eval `scramv1 runtime -sh` 

# Setup c++ library paths and settings
scram setup gcc-cxxcompiler
export PATH="/cvmfs/cms.cern.ch/share/overrides/bin:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw-patch/CMSSW_8_0_26_patch1/bin/slc6_amd64_gcc530:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw-patch/CMSSW_8_0_26_patch1/external/slc6_amd64_gcc530/bin:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_26/bin/slc6_amd64_gcc530:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/llvm/3.8.0-ikhhed/bin:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/bin:/afs/cern.ch/cms/caf/scripts:/cvmfs/cms.cern.ch/common:/cvmfs/cms.cern.ch/bin:/usr/sue/sbin:/usr/sue/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin":$PATH
export LD_LIBRARY_PATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw-patch/CMSSW_8_0_26_patch1/biglib/slc6_amd64_gcc530:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw-patch/CMSSW_8_0_26_patch1/lib/slc6_amd64_gcc530:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw-patch/CMSSW_8_0_26_patch1/external/slc6_amd64_gcc530/lib:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_26/biglib/slc6_amd64_gcc530:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_26/lib/slc6_amd64_gcc530:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/llvm/3.8.0-ikhhed/lib64:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/lib64:/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_PATH
export LDFLAGS="-Wl,-rpath,/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/lib64 -L /cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/lib64 -Wl,-rpath,/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/lib -L /cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/lib"
export CXX=/cvmfs/cms.cern.ch/slc6_amd64_gcc530/external/gcc/5.3.0/bin/g++

# Compiling bazel
echo "Start compiling bazel"

wget https://github.com/bazelbuild/bazel/releases/download/0.4.5/bazel-0.4.5-dist.zip
unzip bazel-0.4.5-dist.zip 
chmod +x ./compile.sh
./compile.sh
echo "Finished compiling bazel"

# Compiling Tensorflow
echo "Start compiling Tensorflow"
git clone https://github.com/tensorflow/tensorflow
cd tensorflow

# Make sure Tensorflow configure runs non-interactive by setting variables
export PYTHON_BIN_PATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw-patch/CMSSW_8_0_26_patch1/external/slc6_amd64_gcc530/bin/python
export TF_NEED_MKL=0
export CC_OPT_FLAGS="-march=native"
export TF_NEED_JEMALLOC=0
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_ENABLE_XLA=0
export TF_NEED_OPENCL=0
export TF_NEED_CUDA=0

# Configure Tensorflow
echo "Configure Tensorflow"
./configure	

# Patch Protobuf in tensorflow to make sure that non-default gcc installation is used
echo "Patching protobuf"
wget https://raw.githubusercontent.com/mharrend/tensorflow-c--api/master/protobuf-patch.bzl
patch -p1 -i protobuf-patch.bzl

# Compile Tensorflow C++ library
echo "Compiling Tensorflow C++ library"
$JENKINSCMSSWSRCDIR/output/bazel build -s -c opt //tensorflow:libtensorflow_cc.so
cp bazel-bin/tensorflow/libtensorflow_cc.so $JENKINSCMSSWSRCDIR/libtensorflow_cc.so

# Compile Tensorflow PIP package
echo "Compiling Tensorflow PIP package"
$JENKINSCMSSWSRCDIR/output/bazel build -s -c opt //tensorflow/tools/pip_package:build_pip_package
echo "Install PIP dependencies"
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
echo "Build PIP package"
bazel-bin/tensorflow/tools/pip_package/build_pip_package $JENKINSCMSSWSRCDIR/tensorflow_pkg


'''
        }
        
      }
    }
    stage('Deploy') {
      steps {
        echo 'Finishing...'
        mattermostSend(message: 'Tensorflow-C++-API and PIP package build finished', channel: 'ttHGroup-devel', color: 'green')
      }
    }
  }
}
