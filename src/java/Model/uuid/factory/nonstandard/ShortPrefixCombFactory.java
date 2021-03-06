/*
 * MIT License
 * 
 * Copyright (c) 2018-2022 Fabio Lima
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package Model
.uuid.factory.nonstandard;

import java.time.Clock;
import java.util.Random;
import java.util.UUID;

import Model
.uuid.enums.UuidVersion;
import Model
.uuid.factory.AbstRandomBasedFactory;
import Model
.uuid.factory.function.RandomFunction;
import Model
.uuid.factory.function.impl.DefaultRandomFunction;
import Model
.uuid.util.internal.ByteUtil;

/**
 * Factory that creates Prefix COMB GUIDs.
 * 
 * A Prefix COMB GUID is a UUID that combines a creation time with random bits.
 * 
 * The creation minute is a 2 bytes PREFIX at the MOST significant bits.
 * 
 * The prefix wraps around every ~45 days (2^16/60/24 = ~45).
 * 
 * Read: Sequential UUID Generators
 * https://www.2ndquadrant.com/en/blog/sequential-uuid-generators/
 * 
 */
public final class ShortPrefixCombFactory extends AbstRandomBasedFactory {

	private final Clock clock;
	private final int interval;

	// default interval length in milliseconds
	private static final int DEFAULT_INTERVAL = 60_000;

	public ShortPrefixCombFactory() {
		this(new DefaultRandomFunction());
	}

	public ShortPrefixCombFactory(Random random) {
		this(getRandomFunction(random));
	}

	public ShortPrefixCombFactory(Random random, Clock clock) {
		this(getRandomFunction(random), clock);
	}

	public ShortPrefixCombFactory(Random random, Clock clock, int interval) {
		this(getRandomFunction(random), clock, interval);
	}

	public ShortPrefixCombFactory(RandomFunction randomFunction) {
		this(randomFunction, Clock.systemUTC(), DEFAULT_INTERVAL);
	}

	public ShortPrefixCombFactory(RandomFunction randomFunction, Clock clock) {
		this(randomFunction, clock, DEFAULT_INTERVAL);
	}

	public ShortPrefixCombFactory(RandomFunction randomFunction, Clock clock, int interval) {
		super(UuidVersion.VERSION_RANDOM_BASED, randomFunction);
		this.clock = clock != null ? clock : Clock.systemUTC();
		this.interval = interval;
	}

	/**
	 * Returns a Prefix COMB GUID.
	 * 
	 * It combines creation time with random bits.
	 * 
	 * The creation minute is a 2 bytes PREFIX at the MOST significant bits.
	 * 
	 * The prefix wraps around every ~45 days (2^16/60/24 = ~45).
	 */
	@Override
	public UUID create() {

		// Get random values for MSB and LSB
		final byte[] bytes = this.randomFunction.apply(14);
		long msb = ByteUtil.toNumber(bytes, 8, 14);
		long lsb = ByteUtil.toNumber(bytes, 0, 8);

		// Insert the short prefix in the MSB
		final long timestamp = clock.millis() / interval;
		msb |= ((timestamp & 0x000000000000ffffL) << 48);

		// Set the version and variant bits
		return getUuid(msb, lsb);
	}
}
