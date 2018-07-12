MAKEFLAGS=--warn-undefined-variables

SRCFOLDER := lambda
LAMBDAS := copy_snapshots_dest_rds copy_snapshots_no_x_account_rds delete_old_snapshots_dest_rds delete_old_snapshots_no_x_account_rds delete_old_snapshots_rds share_snapshots_rds take_snapshots_rds
buildLAMBDAS := $(LAMBDAS)
RELEASE := $(shell git describe --tags HEAD)


build: $(buildLAMBDAS)
	
$(buildLAMBDAS):
	echo "Build $@"
	echo "Release: $(RELEASE)"
	mkdir -p output
	cd $(SRCFOLDER)/$@ && zip ../../output/$@.zip *
all: clean build upload
clean:
	rm -f output/*.zip
upload:
	aws --profile cbc-prod s3 cp  output/ s3://clouds-configuration/clouds/lambda/rds-snapshot-tool/latest/ --recursive
	aws --profile cbc-prod s3 cp  output/ s3://clouds-configuration/clouds/lambda/rds-snapshot-tool/$(RELEASE)/ --recursive

