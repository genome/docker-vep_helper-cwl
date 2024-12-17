FROM ensemblorg/ensembl-vep:release_113.3
LABEL maintainer="John Garza <johnegarza@wustl.edu>"
LABEL description="Vep helper image"

USER root

RUN apt-get update -y && apt-get install -y \
libfile-copy-recursive-perl \
libipc-run-perl \
wget

#necessary because some legacy cwl files still refer to vep (the current name) as variant_effect_predictor.pl
WORKDIR /
RUN ln -s /opt/vep/src/ensembl-vep/vep /usr/bin/variant_effect_predictor.pl

WORKDIR /opt/vep/src/ensembl-vep
RUN perl INSTALL.pl --NO_UPDATE

RUN mkdir -p /opt/lib/perl/VEP/Plugins
WORKDIR /opt/lib/perl/VEP/Plugins

RUN wget https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/Downstream.pm \
https://raw.githubusercontent.com/griffithlab/pVACtools/master/pvactools/tools/pvacseq/VEP_plugins/Wildtype.pm \
https://raw.githubusercontent.com/griffithlab/pVACtools/master/pvactools/tools/pvacseq/VEP_plugins/Frameshift.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/CADD.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/REVEL.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/pLI.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/pLI_values.txt \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/LoFtool.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/LoFtool_scores.txt \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/SpliceRegion.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/dbNSFP.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/113/dbNSFP_replacement_logic

COPY vcf_check.pl /usr/bin/vcf_check.pl

USER vep
