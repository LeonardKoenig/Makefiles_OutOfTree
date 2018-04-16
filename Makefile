
# Build options
BUILDOPT ?= debug

ifeq ($(BUILDOPT),release)
	CPPFLAGS += -DNDEBUG
	CFLAGS += -O2
else
	CFLAGS += -Og -g3
endif


# Default rule
all: client


# Collect objects
CLIENT_OBJ=
SOCKET_OBJ=
include src/inc.mk


# Rules
## Compile rules
target/$(BUILDOPT)/out/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -c -o $@

## Link rules
client: target/$(BUILDOPT)/client
target/$(BUILDOPT)/client: $(addprefix target/$(BUILDOPT)/out/, $(CLIENT_OBJ)) target/$(BUILDOPT)/libsockets.a
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $^ -o $@

sockets: target/$(BUILDOPT)/libsockets.a
target/$(BUILDOPT)/libsockets.a: $(addprefix target/$(BUILDOPT)/out/, $(SOCKET_OBJ))
	$(AR) -cvq $@ $^

## Clean rules
clean:
	@$(RM) -v $(addprefix target/$(BUILDOPT)/out/, $(CLIENT_OBJ)) target/$(BUILDOPT)/client
cleanall:
	@$(RM) -rv target/

## Pseudo-Rules
.PHONY: all client sockets clean cleanall
.SUFFIXES:
