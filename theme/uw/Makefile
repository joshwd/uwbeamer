LOGS=base.log law.log econ.log fi.log fsps.log fss.log med.log \
	ped.log phil.log sci.log
OUTPUT= \
	beamercolorthemeuwbeamer-mu.sty	beamerfontthemeuwbeamer-mu.sty \
	beamerinnerthemeuwbeamer-mu.sty beamerouterthemeuwbeamer-mu.sty \
	beamercolorthemeuwbeamer-mu-law.sty \
	beamercolorthemeuwbeamer-mu-econ.sty \
	beamercolorthemeuwbeamer-mu-fi.sty \
	beamercolorthemeuwbeamer-mu-fsps.sty \
	beamercolorthemeuwbeamer-mu-fss.sty \
	beamercolorthemeuwbeamer-mu-med.sty \
	beamercolorthemeuwbeamer-mu-ped.sty \
	beamercolorthemeuwbeamer-mu-phil.sty \
	beamercolorthemeuwbeamer-mu-sci.sty

.PHONY: explode implode clean all
all: explode
explode: $(LOGS)

%.log: %.ins %.dtx
	xetex $<

implode:
	rm -f $(OUTPUT) $(LOGS)
