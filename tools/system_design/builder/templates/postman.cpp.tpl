// ----------------------------------------------------------------------------
/*
 * WARNING: This file is generated automatically, do not edit!
 * Please modify the corresponding XML file instead.
 */
// ----------------------------------------------------------------------------

#include <xpcc/communication.hpp>
{% for component in components %}
#include "component_{{ component.name | camelcase }}/{{ component.name | camelcase }}.hpp"
{%- endfor %}

#include "packets.hpp"
#include "identifier.hpp"
#include "postman.hpp"

namespace component
{
	{%- for component in components %}
	extern {{ component.name | CamelCase }}	{{ component.name | camelCase }};
	{%- endfor %}
}

// ----------------------------------------------------------------------------
xpcc::Postman::DeliverInfo
Postman::deliverPacket(const xpcc::Header& header, const xpcc::SmartPointer& payload)
{
	xpcc::ResponseHandle response(header);

	// Avoid warnings about unused variables
	(void) payload;
	(void) response;

	switch (header.destination)
	{
{%- for component in components %}
		case robot::component::{{ component.name | CAMELCASE }}:
		{
			switch (header.packetIdentifier)
			{
	{%- for action in component.actions %}
		{%- if action.parameterType != None %}
			{%- set typePrefix = "" if action.parameterType.isBuiltIn else "robot::packet::" %}
			{%- set payload = ", payload.get<" ~ typePrefix ~ (action.parameterType.name | CamelCase) ~ ">()" %}
			{%- set arguments = "const " ~ typePrefix ~ (action.parameterType.name | CamelCase) ~ "& payload" %}
		{%- else %}
			{%- set payload = "" %}
			{%- set arguments = "" %}
		{%- endif %}
				case robot::action::{{ action.name | CAMELCASE }}:
		{%- if action.call == "coroutine" %}
					if (component_{{ component.name | camelCase }}_action{{ action.name | CamelCase }}(response{{ payload }}) > xpcc::co::NestingError) {
						// put into queue
					}
		{%- else %}
			{%- if action.parameterType != None %}
				{%- set payload = ", &payload.get<" ~ typePrefix ~ (action.parameterType.name | CamelCase) ~ ">()" %}
				{%- set arguments = ", const " ~ typePrefix ~ (action.parameterType.name | CamelCase) ~ " *payload" %}
			{%- endif %}
					// void action{{ action.name | CamelCase }}(const xpcc::ResponseHandle& responseHandle{{ arguments }});
					component::{{ component.name | camelCase }}.action{{ action.name | CamelCase }}(response{{ payload }});
		{%- endif %}
					return OK;
	{%- endfor %}

				default:
					return NO_ACTION;
			}
			break;
		}
{% endfor %}

		// Events
		case 0:
			switch (header.packetIdentifier)
			{
{%- for event in container.events.subscribe %}
				case robot::event::{{ event.name | CAMELCASE }}:
	{%- for component in eventSubscriptions[event.name] %}
		{%- if events[event.name].type != None %}
					// void event{{ event.name | CamelCase }}(const xpcc::Header& header, const robot::packet::{{ events[event.name].type.name | CamelCase }} *payload);
					component::{{ component.name | camelCase }}.event{{ event.name | CamelCase }}(header, &payload.get<robot::packet::{{ events[event.name].type.name | CamelCase }}>());
		{%- else %}
					// void event{{ event.name | CamelCase }}(const xpcc::Header& header);
					component::{{ component.name | camelCase }}.event{{ event.name | CamelCase }}(header);
		{%- endif %}
	{%- endfor %}
					break;
{% endfor %}
				default:
					break;
			}
			return OK;

		default:
			return NO_COMPONENT;
	}

	return NOT_IMPLEMENTED_YET_ERROR;
}

// ----------------------------------------------------------------------------
bool
Postman::isComponentAvaliable(uint8_t component) const
{
	switch (component)
	{
{%- for component in components %}
		case robot::component::{{ component.name | CAMELCASE }}:
{%- endfor %}
			return true;
			break;

		default:
			return false;
	}
}

void
Postman::update()
{
	// tumbleweed
}

// ----------------------------------------------------------------------------
{%- for component in components %}
	{%- for action in component.actions %}
		{%- if action.call == "coroutine" %}
uint8_t
			{%- if action.parameterType != None %}
				{%- set typePrefix = "" if action.parameterType.isBuiltIn else "robot::packet::" %}
				{%- set arguments = ", const " ~ typePrefix ~ (action.parameterType.name | CamelCase) ~ "& payload" %}
				{%- set payload = "payload" %}
			{%- else %}
				{%- set arguments = "" %}
				{%- set payload = "" %}
			{%- endif %}
Postman::component_{{ component.name | camelCase }}_action{{ action.name | CamelCase }}(const xpcc::ResponseHandle& response{{ arguments }})
{
	auto result = component::{{ component.name | camelCase }}.action{{ action.name | CamelCase }}({{ payload }});
	if (result.state <= xpcc::co::NestingError) {
		if (result.result.response == xpcc::Response::Positive) {
			{%- if action.returnType != None %}
			component::{{component.name | camelCase}}.getCommunicator()->sendResponse(response, result.result.data);
			{%- else %}
			component::{{component.name | camelCase}}.getCommunicator()->sendResponse(response);
			{%- endif %}
		} else {
			component::{{component.name | camelCase}}.getCommunicator()->sendNegativeResponse(response);
		}
	}
	return result.state;
}
		{%- endif %}
	{%- endfor %}
{%- endfor %}
