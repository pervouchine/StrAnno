.PHONY : all

all :: hg19/trackDB.txt hg38/trackDB.txt

hg19/trackDB.txt : ../human/hg19/rin/list.txt
	for f in `ls ../human/hg19/rin/*.bed`; do echo $$f; g=$$(basename $$f); sort -k1,1 -k2,2n $$f > hg19/$$g; ../bedToBigBed hg19/$$g hg19/hg19.chrom.sizes hg19/$${g%.*}.bb; done
	awk -v f=../palette_rin.dat -v FS="\t" 'BEGIN{while(getline<f>0){c[$$2]=$$3} print "track RINclass\nsuperTrack on show\nshortLabel RIN class\nlongLabel Structural annotation by RIN class\n\n"}{print "track "$$1"\nparent RINclass\nbigDataUrl "$$1".bb\nshortLabel "$$1"\nlongLabel "$$1"\ntype bigBed\nvisibility 1\nitemRgb on\ncolor "c[$$1]"\n"}' ../human/hg19/rin/list.txt > hg19/trackDB.txt


hg38/trackDB.txt : ../human/hg38/rin/list.txt
	#for f in `ls ../human/hg38/rin/*.bed`; do echo $$f; g=$$(basename $$f); sort -k1,1 -k2,2n $$f > hg38/$$g; ../bedToBigBed hg38/$$g hg38/hg38.chrom.sizes hg38/$${g%.*}.bb; done
	awk -v f=../palette_rin.dat -v FS="\t" 'BEGIN{while(getline<f>0){c[$$2]=$$3} print "track RINclass\nsuperTrack on show\nshortLabel RIN class\nlongLabel Structural annotation by RIN class\n\n"}{print "track "$$1"\nparent RINclass\nbigDataUrl "$$1".bb\nshortLabel "$$1"\nlongLabel "$$1"\ntype bigBed\nvisibility 1\nitemRgb on\ncolor "c[$$1]"\n"}' ../human/hg38/rin/list.txt > hg38/trackDB.txt

