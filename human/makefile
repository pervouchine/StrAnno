SCRIPTS=../scripts/
.PHONY : all

all :: proteome_full_cds.tsv positions.tsv rin_classes.tsv ss_classes.tsv
	make -C hg19/
	make -C hg38/

# Download human ID mapping from uniprot
#HUMAN_9606_idmapping.dat :
#	wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/by_organism/HUMAN_9606_idmapping.dat.gz
#	gunzip HUMAN_9606_idmapping.dat.gz
# Select uniprot_id -> ensembl_tr map and drop ensembl_tr with >1 uniprot_id
#uniprot_ens_tr.tsv : HUMAN_9606_idmapping.dat
#	awk '$$2=="Ensembl_TRS"' HUMAN_9606_idmapping.dat | awk -v OFS="\t" '{s[$$3]=$$1;n[$$3]++}END{for(j in s){if(n[j]==1){print j, s[j]}}}' > uniprot_ens_tr.tsv

# 1. Download human structural annotation
proteome.classification.tsv :
	wget http://arkuda.skoltech.ru/~dp/shared/stranno/human.proteome.classification.tsv > proteome.classification.tsv

# 2. Extract protein sequences
proteome.tsv : proteome.classification.tsv
	tail -n+2 proteome.classification.tsv | perl ${SCRIPTS}extract_protein_seq.pl > proteome.tsv
	wc -l proteome.tsv

# 3. Remove incomplete sequences
proteome_full_cds.tsv : proteome.tsv
	awk '$$2!~/X/' proteome.tsv > proteome_full_cds.tsv
	wc -l proteome_full_cds.tsv

# 4. Create short description of positions
positions.tsv : proteome.classification.tsv
	tail -n+2 proteome.classification.tsv | awk -v FS="\t" '$$13!="-"' | cut -f1,6,7 > positions.tsv

# 5a. RIN_classes.tsv
rin_classes.tsv : proteome.classification.tsv
	tail -n+2 proteome.classification.tsv | awk -v FS="\t" -v f=../palette_rin.dat 'BEGIN{while(getline<f>0){name[$$1]=$$2}}{if(name[$$13]){split($$17,a," ");print $$1":"$$7":"$$6"\t"name[$$13]"\t"a[1]}}' > rin_classes.tsv

ss_classes.tsv : proteome.classification.tsv
	tail -n+2 proteome.classification.tsv | awk -v FS="\t" -v f=../palette_ss.dat 'BEGIN{while(getline<f>0){name[$$1]=$$2}}{if(name[$$16]){split($$17,a," ");print $$1":"$$7":"$$6"\t"name[$$16]"\t"a[1]}}' > ss_classes.tsv



