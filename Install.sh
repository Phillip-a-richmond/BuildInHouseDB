# Get Conda if you don't have it
set -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OPT_DIR=${DIR}/opt

mkdir -p $OPT_DIR

CONDA=Miniconda3-latest-Linux-x86_64.sh
MINICONDA_DIR=${OPT_DIR}/miniconda3

if [[ ! -d ${MINICONDA_DIR} ]]; then
wget -q https://repo.continuum.io/miniconda/${CONDA}\
    && sh ${CONDA} -b -p ${MINICONDA_DIR}\
    && rm -f ${CONDA}
fi

# Build an environment according to the yml
$MINICONDA_DIR/condabin/conda env create \
	-f InHouseDB_environment.yml \
	--prefix ${OPT_DIR}/InHouseDB_environment

# Test activate
source $MINICONDA_DIR/etc/profile.d/conda.sh
conda activate ${OPT_DIR}/InHouseDB_environment
