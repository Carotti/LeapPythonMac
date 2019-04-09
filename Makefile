LEAPSDK = ./LeapSDK
LEAPPYTHON = ./LeapPython

PYTHON = python3.6

define python_config
    $(shell $(PYTHON) -c 'from distutils import sysconfig; print(sysconfig.get_config_var("$(1)"))')
endef

PYTHON_LIB = $(call python_config,LIBDIR)
PYTHON_INCLUDE = $(call python_config,INCLUDEDIR)

all: $(LEAPPYTHON)/__init__.py $(LEAPPYTHON)/libLeap.dylib $(LEAPPYTHON)/LeapPython.so

ifeq ($(shell test -d $(LEAPSDK); echo $$?),1)
$(LEAPSDK): Leap_Motion_SDK_*.tgz
	tar -xvf $^
	mv LeapDeveloperKit_*/LeapSDK/ .
	rm -rf $^ LeapDeveloperKit_*/
else
$(LEAPSDK):
endif

$(LEAPPYTHON): $(LEAPSDK)
	mkdir -p $@

$(LEAPPYTHON)/LeapPython.cpp: $(LEAPSDK)/include/Leap.i | $(LEAPPYTHON)
	perl -i -pe 's/%}}/}}/g' $(LEAPSDK)/include/Leap.i
	swig -c++ -python -o $@ -interface LeapPython $^

$(LEAPPYTHON)/LeapPython.so: $(LEAPPYTHON)/LeapPython.cpp $(LEAPSDK)/lib/libLeap.dylib $(PYTHON_LIB)/lib*.dylib  | $(LEAPPYTHON)
	$(CXX) -I$(LEAPSDK)/include -I$(PYTHON_INCLUDE)/*m $^ -shared -o $@

$(LEAPPYTHON)/libLeap.dylib: $(LEAPSDK)/lib/libLeap.dylib | $(LEAPPYTHON)
	ln $< $@

$(LEAPPYTHON)/__init__.py: | $(LEAPPYTHON)
	touch $@