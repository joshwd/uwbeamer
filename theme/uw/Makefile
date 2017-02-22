LOGS=base.log aae.log
OUTPUT= \
	beamercolorthemeuwbeamer.sty	beamerfontthemeuwbeamer.sty \
	beamerinnerthemeuwbeamer.sty beamerouterthemeuwbeamer.sty \
	beamercolorthemeuwbeamer-aae.sty

.PHONY: explode implode clean all
all: explode
explode: $(LOGS)

%.log: %.ins %.dtx
	xetex $<

implode:
	rm -f $(OUTPUT) $(LOGS)
