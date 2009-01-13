<!---	$Id$		Copyright 2007 Brian Ghidinelli (http://www.ghidinelli.com/)		Licensed under the Apache License, Version 2.0 (the "License"); you 	may not use this file except in compliance with the License. You may 	obtain a copy of the License at:	 		http://www.apache.org/licenses/LICENSE-2.0		 	Unless required by applicable law or agreed to in writing, software 	distributed under the License is distributed on an "AS IS" BASIS, 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 	See the License for the specific language governing permissions and 	limitations under the License.---><cfcomponent name="eft" output="false" hint="Object for holding EFT account data">	<cfproperty name="firstName" type="string" default="" />	<cfproperty name="lastName" type="string" default="" />	<cfproperty name="address" type="string" default="" />	<cfproperty name="address2" type="string" default="" />	<cfproperty name="city" type="string" default="" />	<cfproperty name="region" type="string" default="" />	<cfproperty name="postalCode" type="string" default="" />	<cfproperty name="country" type="string" default="" />	<cfproperty name="phoneNumber" type="string" default="" />	<cfproperty name="account" type="numeric" default="" />	<cfproperty name="routingNumber" type="numeric" default="" />	<cfproperty name="checkNumber" type="numeric" default="" />	<cfproperty name="accountType" type="string" default="" />	<cfproperty name="SEC" type="string" default="" />	<!---	PROPERTIES	--->	<cfset variables.instance = structNew() />	<cfset variables.instance.firstName = "" />	<cfset variables.instance.lastName = "" />	<cfset variables.instance.address = "" />	<cfset variables.instance.address2 = "" />	<cfset variables.instance.city = "" />	<cfset variables.instance.region = "" />	<cfset variables.instance.postalCode = "" />	<cfset variables.instance.country = "" />	<cfset variables.instance.phoneNumber = "" />	<cfset variables.instance.account = "" />	<cfset variables.instance.routingNumber = "" />	<!--- check numbers can have arbitrary values --->	<cfset variables.instance.checkNumber = "" />	<!--- account type is typically "checking", "savings", etc.  Used by some ACH transactions if not implied. --->	<cfset variables.instance.accountType = "" />	<!--- Standard Entry Class or SEC Code: http://en.wikipedia.org/wiki/Automated_Clearing_House#Standard_entry_class_code --->	<cfset variables.instance.SEC = "WEB" /><!--- WEB is implicit in e-check transactions but is required for all EFTs by NACHA regulations --->	<!---	INITIALIZATION / CONFIGURATION	--->	<cffunction name="init" access="public" returntype="eft" output="false">		<cfreturn this /> 	</cffunction>	<!--- convenience boolean wrapper around validate() --->	<cffunction name="getIsValid" access="public" returntype="boolean" output="false" hint="True/false the bank account is valid">		<cfreturn arrayLen(validate()) EQ 0 />	</cffunction>		<!--- if we pass this successfully, we should be able to send it to the gateway safely --->	<cffunction name="validate" access="public" returntype="any" output="false">		<cfset var errors = arrayNew(1) />		<cfset var thisError = structNew() />		<!--- EFT data requiresments based on iTransact/PaymentClearing.com:						Field Name 			Required				FirstName 			Yes				LastName 			Yes				PhoneNumber 		Yes				Address1 			No				Address2 			No				BirthDate			No				City 				No				CustomerEmail 		No				CheckNumber 		No				DriversLicenseNumber No				DriversLicenseState No				PostalCode 			No				State 				No				SSN 				No			  		--->		<!--- First Name --->		<cfif (NOT len(trim(getFirstName())))>			<cfset thisError.field = "firstName" />			<cfset thisError.type = "required" />			<cfset thisError.message = "First name is required" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>				<!--- Last Name --->		<cfif NOT len(trim(getLastName()))>			<cfset thisError.field = "lastName" />			<cfset thisError.type = "required" />			<cfset thisError.message = "Last name is required" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<!--- Last Name --->		<cfif NOT len(trim(getPhoneNumber()))>			<cfset thisError.field = "phoneNumber" />			<cfset thisError.type = "required" />			<cfset thisError.message = "Phone number is required" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<!--- Account Number (length/formatting greatly varies from bank to bank) --->		<cfif NOT len(getAccount())>			<cfset thisError.field = "account" />			<cfset thisError.type = "required" />			<cfset thisError.message = "Account number is required" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<cfif len(getAccount()) AND NOT isNumeric(getAccount())>			<cfset thisError.field = "account" />			<cfset thisError.type = "invalidType" />			<cfset thisError.message = "Account number is not numeric" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<!--- ABA Routing Number --->		<cfif NOT len(getRoutingNumber())>			<cfset thisError.field = "routingNumber" />			<cfset thisError.type = "required" />			<cfset thisError.message = "Routing number is required" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<cfif len(getRoutingNumber()) AND NOT isNumeric(getRoutingNumber())>			<cfset thisError.field = "routingNumber" />			<cfset thisError.type = "invalidType" />			<cfset thisError.message = "Routing number is not numeric" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<cfif len(getAccount()) AND NOT isABA(getRoutingNumber())>			<cfset thisError.field = "routingNumber" />			<cfset thisError.type = "invalidValue" />			<cfset thisError.message = "Routing number is invalid" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<!--- Check Number --->		<cfif len(getCheckNumber()) AND NOT isNumeric(getCheckNumber())>			<cfset thisError.field = "checkNumber" />			<cfset thisError.type = "invalidType" />			<cfset thisError.message = "Check number is not numeric" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<!--- Check Number --->		<cfif NOT len(getCheckNumber())>			<cfset thisError.field = "SEC" />			<cfset thisError.type = "required" />			<cfset thisError.message = "SEC code is required by NACHA regulations" />			<cfset arrayAppend(errors, duplicate(thisError)) />		</cfif>		<cfreturn errors />	</cffunction>	<!---	ACCESSORS	--->	<cffunction name="setFirstName" access="public" returntype="any"><cfset variables.instance.firstName = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getFirstName" access="public" returntype="any"><cfreturn variables.instance.firstName /></cffunction>	<cffunction name="setLastName" access="public" returntype="any"><cfset variables.instance.lastName = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getLastName" access="public" returntype="any"><cfreturn variables.instance.lastName /></cffunction>	<cffunction name="getName" access="public" returntype="any" hint="I return the firstname and last name as one string.">		<cfset var ret = getFirstName() />		<cfif len(ret) and len(getLastName())>			<cfset ret = ret & " " />		</cfif>		<cfset ret = ret & getLastName() />		<cfreturn ret />	</cffunction>	<cffunction name="setAddress" access="public" returntype="any"><cfset variables.instance.address = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getAddress" access="public" returntype="any"><cfreturn variables.instance.address /></cffunction>	<cffunction name="setAddress2" access="public" returntype="any"><cfset variables.instance.address2 = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getAddress2" access="public" returntype="any"><cfreturn variables.instance.address2 /></cffunction>	<cffunction name="setCity" access="public" returntype="any"><cfset variables.instance.city = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getCity" access="public" returntype="any"><cfreturn variables.instance.city /></cffunction>	<cffunction name="setRegion" access="public" returntype="any" hint="Region is synonym for State or Province"><cfset variables.instance.region = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getRegion" access="public" returntype="any"><cfreturn variables.instance.region /></cffunction>	<cffunction name="setPostalCode" access="public" returntype="any"><cfset variables.instance.postalCode = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getPostalCode" access="public" returntype="any"><cfreturn variables.instance.postalCode /></cffunction>	<cffunction name="setCountry" access="public" returntype="any"><cfset variables.instance.country = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getCountry" access="public" returntype="any"><cfreturn variables.instance.country /></cffunction>	<cffunction name="setPhoneNumber" access="public" returntype="any"><cfset variables.instance.PhoneNumber = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getPhoneNumber" access="public" returntype="any"><cfreturn variables.instance.PhoneNumber /></cffunction>	<cffunction name="setAccount" access="public" returntype="any"><cfset variables.instance.account = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>	<cffunction name="getAccount" access="public" returntype="any"><cfreturn variables.instance.account /></cffunction>	<cffunction name="getAccountMasked" access="public" returntype="any" hint="Display the account number masked for security purposes">		<cfset var num = getAccount() />		<cfif len(num) GT 5>			<cfreturn repeatString("X", len(num) - 5) & right(num, 5) />		<cfelse>			<!--- this is a weak ass account number --->			<cfreturn num />		</cfif>	</cffunction>	<cffunction name="setRoutingNumber" access="public" returntype="any"><cfset variables.instance.routingNumber = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>	<cffunction name="getRoutingNumber" access="public" returntype="any"><cfreturn variables.instance.routingNumber /></cffunction>	<cffunction name="setCheckNumber" access="public" returntype="any"><cfset variables.instance.checkNumber = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>	<cffunction name="getCheckNumber" access="public" returntype="any"><cfreturn variables.instance.checkNumber /></cffunction>	<cffunction name="setAccountType" access="public" returntype="any"><cfset variables.instance.AccountType = arguments[1] /><cfreturn this /></cffunction>	<cffunction name="getAccountType" access="public" returntype="any"><cfreturn variables.instance.AccountType /></cffunction>	<cffunction name="setSEC" access="public" returntype="any"><cfset variables.instance.SEC = ucase(arguments[1]) /><cfreturn this /></cffunction>	<cffunction name="getSEC" access="public" returntype="any"><cfreturn variables.instance.SEC /></cffunction>	<!--- private workers for validation / etc --->	<cffunction name="numbersOnly" access="private" returntype="any"><cfreturn reReplace(arguments[1], "[^[:digit:]]", "", "ALL") /></cffunction>	<cffunction name="isABA" access="private" returntype="any">		<cfscript>		/**		 * Checks that a number is a valid ABA routing number.		 * 		 * @param number 	 Number you want to validate as an ABA routing number. 		 * @return Returns a Boolean. 		 * @author Michael Osterman (mosterman@highspeed.com) 		 * @version 1, March 21, 2002 		 */		var j = 0;		var cd = 0; //check-digit value		var result = false;		var modVal = 0; //compared to check-digit		var weights = ArrayNew(1);		var number = getRoutingNumber();				// verify it's worth looking at		if (NOT isNumeric(number)) return false;		if (compare(len(number), 9)) return false;				ArraySet(weights, 1, 8, 0);				//set the weights for the following loop		weights[1] = 3;		weights[2] = 7;		weights[3] = 1;		weights[4] = 3;		weights[5] = 7;		weights[6] = 1;		weights[7] = 3;		weights[8] = 7;				cd = Right(number, 1);				for (i = 1; i lte 8; i = i + 1) 		{			j = j + ((Mid(number, i, 1)) * weights[i]);		}				modVal = ((10 - (j mod 10)) mod 10);				if (modVal eq cd)		{			result = true;		}				return result;		</cfscript>	</cffunction>	<!---	DUMP	--->	<cffunction name="dump" access="public" output="true" return="void">		<cfargument name="abort" type="boolean" default="false" />		<cfdump var="#variables.instance#" />		<cfif arguments.abort>			<cfabort />		</cfif>	</cffunction>	<!--- 	Date: 7/6/2008  Usage: return a copy of the internal values --->	<cffunction name="getMemento" output="false" access="public" returntype="any" hint="return a copy of the internal values">		<cfreturn duplicate(variables.instance) />			</cffunction></cfcomponent>