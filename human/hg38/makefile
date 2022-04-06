.PHONY : all
include setup.mk

all :: rin/list.txt ss/list.txt

# 1. Download genome fasta file
genome.fa : 
	wget ${GENOME} -O genome.fa.gz
	gunzip genome.fa.gz

# 2. Download annotation gtf files
# 2a. GENCODE
gencode.gtf :
	wget ${ANNOT} -O gencode.gtf.gz
	gunzip gencode.gtf.gz
	wc -l gencode.gtf

# 2b. REFSEQ
refseq.tsv :
	wget ${REFSEQ} -O refseq.tsv.gz
	gunzip refseq.tsv.gz
	wc -l refseq.tsv

# 2c. Convert REFSEQ to GENCODE
refseq.gtf : refseq.tsv
	perl ${SCRIPTS}refseq2gtf.pl < refseq.tsv > refseq.gtf

# 2d. Merge REFSEQ and GENCODE
annot.gtf : gencode.gtf refseq.gtf
	cat gencode.gtf refseq.gtf | awk '$$1!~/\_/' > annot.gtf
	wc -l annot.gtf

# 3. Extract CDS segments
CDS.bed : annot.gtf
	awk '$$3=="CDS"' annot.gtf | awk -v OFS="\t" '{print $$1, $$4-1, $$5, $$1"_"$$4"_"$$5"_"$$7, 1, $$7}' | sort -u > CDS.bed
	wc -l CDS.bed

# 4. Extract CDS nucleotide sequences
CDS.tsv : genome.fa CDS.bed 
	perl ${SCRIPTS}getfasta.pl genome.fa < CDS.bed > CDS.tsv
	wc -l CDS.tsv

# 5. Extract CDS transcript relationship
CDS_transcript.bed : annot.gtf
	awk '$$3=="CDS"' annot.gtf | grep 'transcript_type "protein_coding";\|transcript_type "nonsense_mediated_decay";' | grep -v end_NF |grep -v start_NF | perl ${SCRIPTS}print_gff_attributes.pl GEN transcript_id > CDS_transcript.bed
	wc -l CDS_transcript.bed

# ??? remove redundant transcripts?

# 6. Translate transcripts
translated_tr.tsv : CDS.tsv CDS_transcript.bed ../../genetic_code.dat
	perl ${SCRIPTS}translate.pl CDS.tsv ../../genetic_code.dat < CDS_transcript.bed > translated_tr.tsv
	wc -l translated_tr.tsv
	cut -f2 translated_tr.tsv | sort -u | wc -l

# 7. Establish uniprot_id <-> transcript_id correspondence
# (if two uniprot entries have the same sequence, StrAnno must be the same?)
# (if two translation have the same sequence, transcript doesn't matter?)
uniprot_tr.tsv : translated_tr.tsv ../proteome_full_cds.tsv
	awk -v f=translated_tr.tsv 'BEGIN{while(getline<f>0){tr[$$2]=$$1}}{uniprot[$$2]=$$1}END{for(j in uniprot){if(tr[j]){print uniprot[j]"\t"tr[j]}}}' ../proteome_full_cds.tsv > uniprot_tr.tsv
	wc -l uniprot_tr.tsv

# 8. Map uniprotid:pos:aa to the genome, each nt -> list of uniprotid:pos:aa
mapping.bed : CDS_transcript.bed ../positions.tsv uniprot_tr.tsv 
	perl ${SCRIPTS}map.pl CDS_transcript.bed ../positions.tsv < uniprot_tr.tsv > mapping.bed
	wc -l mapping.bed

# 9. Create tracks unsorted BED files for RIN classes
rin/list.txt : ../rin_classes.tsv ../../palette_rin.dat mapping.bed
	mkdir -p rin
	perl ${SCRIPTS}track.pl ../rin_classes.tsv ../../palette_rin.dat rin/ < mapping.bed > rin/list.txt


#10. Create tracks unsorted BED files for SS classes
ss/list.txt : ../ss_classes.tsv ../../palette_ss.dat mapping.bed
	mkdir -p ss
	perl ${SCRIPTS}track.pl ../ss_classes.tsv ../../palette_ss.dat ss/ < mapping.bed > ss/list.txt
