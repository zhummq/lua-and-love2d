local newdecoder = require 'lunajsons/decoder'
local newencoder = require 'lunajsons/encoder'
local sax = require 'lunajsons/sax'
-- If you need multiple contexts of decoder and/or encoder,
-- you can require lunajson.decoder and/or lunajson.encoder directly.
return {
	decode = newdecoder(),
	encode = newencoder(),
	newparser = sax.newparser,
	newfileparser = sax.newfileparser,
}
