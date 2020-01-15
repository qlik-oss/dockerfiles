.github/workflows/build.yml: .github/workflows/build.yml.tmpl */.ignore */Dockerfile */*requirements.txt
	@gomplate -c dir=./ -f $< -o $@

.DELETE_ON_ERROR:
.SECONDARY:
