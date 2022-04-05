FROM ensemblorg/ensembl-vep:release_101.0
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

RUN wget https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/Downstream.pm \
https://raw.githubusercontent.com/griffithlab/pVACtools/master/tools/pvacseq/VEP_plugins/Wildtype.pm \
https://raw.githubusercontent.com/griffithlab/pVACtools/master/tools/pvacseq/VEP_plugins/Frameshift.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/CADD.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/REVEL.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/ExACpLI.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/ExACpLI_values.txt \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/LoFtool.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/LoFtool_scores.txt \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/SpliceRegion.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/dbNSFP.pm \
https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/95/dbNSFP_replacement_logic

COPY vcf_check.pl /usr/bin/vcf_check.pl

USER vep
