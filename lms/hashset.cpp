// Creates a hash set of K's for each N.  Has to be called from C, so we need an interface to the real class.
/*
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
 */
#include "hashset.h"
#include <tr1/unordered_set>

std::tr1::unordered_set<uint64_t> khash;

void hashsetup(const float f) {
	khash.max_load_factor(f);
}

void hashadd(const uint64_t v) {
	khash.insert(v);
}

int hashcheck(const uint64_t v) {
	return khash.count(v);
}

void hashfini(void) {
	khash.clear();
}
