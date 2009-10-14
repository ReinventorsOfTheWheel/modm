// coding: utf-8
// ----------------------------------------------------------------------------
/* Copyright (c) 2009, Roboterclub Aachen e.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Roboterclub Aachen e.V. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY ROBOTERCLUB AACHEN E.V. ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ROBOTERCLUB AACHEN E.V. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $Id$
 */
// ----------------------------------------------------------------------------

#ifndef	XPCC__ANGLE_HPP
#define	XPCC__ANGLE_HPP

namespace xpcc
{
	/// \ingroup	math
	/// \brief		Representation of a angle
	class Angle
	{
		public:
			Angle(float angle = 0.0) : angle(angle) {
			}
			
			//! \brief	Limit angle to +-Pi
			void
			normalize();
			
			//! \brief	reverse the angle
			void
			reverse();
			
			float
			getValue() const {
				return this->angle;
			}
			
			Angle&
			operator=(const float& angle) {
				this->angle = angle;
				return *this;
			}
			
			Angle&
			operator+=(const Angle &other);
			
			Angle&
			operator-=(const Angle &other);
		
		private:
			float angle;
	};
}

// ----------------------------------------------------------------------------
inline xpcc::Angle&
xpcc::Angle::operator+=(const Angle &other) {
	this->angle += other.angle;
	return *this;
}

// ----------------------------------------------------------------------------	
inline xpcc::Angle&
xpcc::Angle::operator-=(const Angle &other) {
	this->angle -= other.angle;
	return *this;
}

// ----------------------------------------------------------------------------
inline xpcc::Angle
operator-(const xpcc::Angle &a) {
	return xpcc::Angle(-a.getValue());
}


// ----------------------------------------------------------------------------
inline xpcc::Angle
operator-(const xpcc::Angle &a, const xpcc::Angle &b) {
	return xpcc::Angle(a.getValue() - b.getValue());
}

// ----------------------------------------------------------------------------
inline xpcc::Angle
operator+(const xpcc::Angle &a, const xpcc::Angle &b) {
	return xpcc::Angle(a.getValue() + b.getValue());
}

// ----------------------------------------------------------------------------
inline bool
operator==(const xpcc::Angle &a, const xpcc::Angle &b) {
	return (a.getValue() == b.getValue());
}

// ----------------------------------------------------------------------------
inline bool
operator!=(const xpcc::Angle &a, const xpcc::Angle &b) {
	return (a.getValue() != b.getValue());
}

#endif	// XPCC__ANGLE_HPP
