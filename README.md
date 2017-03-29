# *CAD Customer Personalisation Business Scenario Lab*

# What is it?

This repository will provision an environment that may be used as a Lab to build an end to end scenario that does the following:

*	Place an online order on an eCommerce web site
*   Place an order with a chatbot running on an Azure Bot Service web site
*	Query and create orders on our legacy on-prem Order system 
*	Detect the language that the customer engages with Bot Service on
*	Mail the user with order confirmations and follow ups in their preferred language

# What does it showcase?

This solution brings together Infrastructure as a Service (IaaS), Platform as a Service (PaaS), Software as a Service (SaaS) and Serverless components on Microsoft Azure to build a realistic end to end scenario to provide a personalised service to customers. Furthermore, the democratization of AI is tied in by incorporating Cognitive Services to perform language detection and dynamic translation.

# The end to end scenario

This solution will allow a customer to place an order for a coffee in a multi-channel online store, via website or a chat bot. The language that the user engages with the chat bot on will be determined and stored as personal preferences against the user's record in a locked down legacy database. Future correspondence and order confirmations will be in the customer's preferred communication language.

# The solution aims to show the following:

*	How legacy lift and shift applications on IaaS can be incorporated into modern solutions to quickly derive value from       higher value services in the cloud. 
*	How non-API enabled legacy workloads can be modernised.
*	The ease with which On-premise, public and private components may be brought together to build workloads that bring         business value
*	The meshing of IaaS, PaaS, SaaS, Serverless and AI with tools that are accessible to non-developers
*	OSS workloads running on Azure
*   How Logic Apps can parse and apply JSON schemas to mixed datasources on the fly


# Technology used

The following technology components are used in this solution:

*	eCommerce online store built with Java running on Azure App Services (PaaS)
*	Ubuntu running a legacy mysql database (IaaS) 
*	Azure networking to isolate legacy workloads (IaaS)
*   Azure virtual network Gateway to provide point to site connectivity
*	Serverless components to serve as a proxy between the IaaS legacy database and the PaaS layer (Serverless)
*	Azure logic apps to provide serverless integration that is accessible to non-developers (Serveless)
*   Microsoft Cognitive Services to detect language and translation in real time
*	Azure Resource Manager templates to automate the provisioning and inflation of a full environment

# Solution flow

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/Topology.png "Solution Flow")

# The Lab component

This solution will install and configure all of the components required to build the end to end Personalisation scenario. The Lab attendees just need to apply a few configuration changes and wire everything together in a Logic App. 

# Preparing for the solution

For this Lab you will require:
* A cognitive services trial account key, get it here - https://www.microsoft.com/cognitive-services/en-us/sign-up
* A Gmail account for sending emails, get it here - https://accounts.google.com/SignUp?service=mail&continue=http%3A%2F%2Fmail.google.com%2Fmail%2Fe-11-14a952576b5f2ffe90ec0dd9823744e0-46a962fbb7947b68059374ddde7f29b5490a6b4d
* Install Postman for REST API troubleshooting, get it here - https://www.getpostman.com
* If using Windows 10 get Bash for Windows - https://msdn.microsoft.com/en-us/commandline/wsl/install_guide or putty if on an older version - http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
* A github account, sign up here - https://github.com/join?source=header-home

# How to install the solution

## 1. Provisioning the components: Select Deploy to Azure to deploy to your Azure instance that you are currently logged in to.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fshanepeckham%2FCADScenario_Personalisation%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fshanepeckham%2FCADScenario_Personalisation%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

Select or create a Resource Group to deploy to and the only parameter you need to change is the Deployment Name - give it any name of 12 characters or less as it will be used to generate a hash to ensure your site names are unique. Make a note of the Deployment Name and Resource Group you have deployed to as we will need them again. 

Note, you can always get the parameters for a deployment by clicking on Resource Groups --> [Resource Group] --> Deployments --> [Deployment] - here you can see status and parameters.

This will take roughly 30 minutes as this will provision:

* Two VNETs
* A virtual network Gateway
* An Ubuntu VM and place in inside the VNET isolated with NSGs
* A Bot Service chat bot running on App Services
* An App Service Web app (eCommerce site) and deploy a Java shopping experience on it
* An App Service serverless function as part of a App Service plan so that it can be connected to the virtual network Gateway
* Storage accounts to house the VM VHD, the Function logging and the App Service logging

## 2. Now we will deploy the Serverless proxy code and the Bot Service code - Select Deploy to Azure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fshanepeckham%2FCADScenario_Personalisation%2Fmaster%2Fazuredeployfunction.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

Make sure you have the same Deployment Name as for the first deploy and ensure you deploy to the same resource group, see image below:

See the image below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/deployParams1.png)

This will take roughly 5 minutes as this will:

* Deploy a number node.js functions to connect directly to a remote mysql instance
* A node.js chat bot shopping experience

## 3. Install the legacy database on the VM and enable connectivity

We could deploy this script as a custom script extension on the VM but that will complicate troubleshooting in a lab scenario so we will manually connect to the machine and run the build script, it is a single install script that will set up everything required.

Navigate to your VM, the default name will be comvmmmm[hash] and navigate to the Overview blade and copy the value in the field Public IP Address/DNS label, see below:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/vmip.png)

We will now ssh onto the machine using Bash for Windows on Windows 10, or putty or just plain old terminal on a mac or Linux.

* Type ssh MiniCADAdmin@[pasted ip address - without value '/none' on the end) e.g. ssh MiniCADAdmin@12.34.56.78 and press enter - see below:

![alt text](https://github.com/shanepeckham/CADHackathon_Loyalty/blob/master/Images/ssh2.jpg)

* Select yes to the message "Are you sure you want to continue connecting"
* Type in password MiniCADAdmin123 - note this is hardcoded in the deploy
* Paste the following in the command line: ``` git clone https://github.com/shanepeckham/CADScenario_Personalisation.git ```
* Now type ``` cd CADScenario_Personalisation ```
* Now type ``` bash installVM.sh ```
* Upon completion you will see a screen similar to that below, with the final status 'Active Internet Connections'

Here you will now see that our legacy database is running IP 10.1.0.4 port 3306 within our VNET. 

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/netstat.png)

## 4. Connect the Serverless proxy to the VNET via the virtual network Gateway

Navigate to the Function component provisioned within Azure, its name will be generated by default with the following format commSQL[hash].

If all has provisioned correctly you should see that 4 functions have been created, namely:

* AddNewCustomerOrder - this will upsert a customer and create an order
* GetCustomer - this will get a customer record and requires the customerId as input
* GetOrder - this will get an order record and requires the orderId as input
* GetOrderByCustomerId - this will get a customer's order by the customerId as input

Note what these functions do as they will be required in the hands-on Lab component.

Click on 'Function app settings' on the bottom left of the screen, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup1.png)

This will navigate you to settings page, now select 'Go To App Service Settings' see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup2.png)

Now select 'Networking', see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup3.png)

Now select 'Setup' in the VNET Integration section, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup4.png)

Now select the VNET connection that we provisioned, it will have the default name legacycommvnet[hash]. If you have many connections just look at the top navigation history and you will see the correct hash prefix, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup5.png)

This will take around a minute and once complete you should see the legacycommvnet[hash] virtual network as a connection, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup6.png)

Now we can go and check whether our Serverless Function proxy can connect to the legacy database running on 10.1.0.4:3306. Click on 'Console', see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup7.png)

In the console type ``` tcpping 10.1.0.4:3306 ``` You should get a successful connection which means our Serverless proxy can now retrieve and update data from the legacy database running on the isolated VNET on behalf of our chat bot and eCommerce web site, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup8.png)

Now we can go test a method to check whether all is working as planned. Navigate back to the code view of the Function and select method 'GetCustomer'. Expand the menu on the right of the page to gain access to the test pane, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup9.png)

Select the Test item and enter the following in the 'Request Body' section and select run, see below:

```
{ "customerId": "1" }
```
![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup10.png)

You should see the result "bobby@turtlenecksweater.com" in the logs below if successful, you might get an error as illustrated below upon first invocation but if you run it again the error should not appear again.
```
2017-03-29T12:45:49.621 Retrieving a single customer
2017-03-29T12:45:54.595 SELECT * FROM customers where customerId = "1"
2017-03-29T12:45:54.627 Function completed (Failure, Id=88f13e38-3867-4f0c-a6aa-d29e1330b309)
2017-03-29T12:45:54.646 Script for function 'GetCustomer' changed. Reloading.
2017-03-29T12:45:54.783 RowDataPacket {
  customerId: 1,
  emailAddress: 'bobby@turtlenecksweater.com',
  preferredLanguage: 'English' }
2017-03-29T12:45:54.955 Exception while executing function: Functions.GetCustomer. mscorlib: ReferenceError: res is not defined
    at module.exports (D:\home\site\wwwroot\GetCustomer\index.js:28:24)
    at D:\Program Files (x86)\SiteExtensions\Functions\1.0.10841\bin\azurefunctions\functions.js:93:24.
```
When you run it again you should see the following, if successful:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/functionsetup11.png)

## 5. Check the eCommerce website is up and running and serving customers

Navigate back to your Resource Group and select your provisioned eCommerce website, it will have a default name of commcoffee[hash]. Now select Browse, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/webcoffee1.png)

This will open a new page and start up your Java eCommerce site. Have a look around, you can order 1 of 4 coffees but we have not yet wired up the web site to the ordering process, we will do this in the hands-on Lab component. The Web site requires an application setting called 'logicAppURL' with the value of the Logic App endpoint which we will create in the hands-on Lab component.

See below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/webcoffee1.png)

## 6. Activate the Bot Service and check the code has deployed

CAVEAT: At the time of writing the Bot Service is still in preview and is therefore prone to all manner of stability issues and unpredictability.

Navigate back to your Resource Group and select your provisioned Bot Service App Service App, it will have a default name of commcombot3[hash]. Now select it and you will be navigated to the setup screen where you will register the Bot App Id so that it can be added to other channels if required, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup1.png)

Click 'Create Microsoft App Id and Password'. This will open up a new window where you will register your Bot App Id. Select 'Generate an app password to continue', see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup2.png)

This will open up a popup with your password in, copy this value for immediate reuse. Note, it only appears this once. Click 'Finish and go back to Bot Framework'. Paste your password in the entry box.

Now select 'NodeJS' in the Choose a Language section and select 'Basic' in the Choose a Template section (at the time of writing this a necessary step even though our code will overwrite these settings) and click 'Create Bot', see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup3.png)

This will take roughly 2-3 minutes, once complete you will be navigated to the code view of the Bot. If all has provisioned correctly you will see the status 'Edit continuous integration'. Click on settings to check the status of the code deploy, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup4.png)

Now click on the 'Edit' dropdown on the right of the screen in the Continuous Integration section, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup5.png)

This will open the Continuous Integration menu. Here you can see the status of the code deploy, see below. Select the Configure Continuous Integration button. 

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup6.png)

This will open a blade on the right which will display the status of the deployment source and latest commit, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup7.png)

Now click on the latest commit, it will open another blade with a 'Redeploy' button, select it. See below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup8.png)

If you navigate back to the code view you should now see the first question "What is your email address?" with the chat emulator loaded to the left. See below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsetup9.png)

Like the coffee website, the chat bot requires an application setting called logicAppURL that maps to the endpoint of the Logic app that will be created in the hands-n Lab component.

# The hands-on Lab component

## SPOILER ALERT - this is the full solution, so only look here if you get stuck!

### The data model

Both the website and the chat bot will take a customer order and provide us with a json request like the following:

```
{   "emailAddress": "bobby@turtlenecksweater.com",
    "preferredLanguage": "French",
    "product": "Latte",
    "total", "$3,45"
}
```
### Registering a Logic App endpoint with the website and the chat bot

Create a new Logic App within your Resource Group and in the same location as your other components.

The first thing we want to do is create a HTTP Request-Response Step, click save - you will receive an endpoint upon save - copy this value, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/logicreqresp.png)

Select 'Use this template'

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/logicresprep2.png)

Now click Save and copy the endpoint

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/copylogicurl.png)

Navigate back to your Resource Group and select your provisioned eCommerce website, it will have a default name of commcoffee[hash]. Select 'Application Settings' and scroll down to 'App Settings' section, add a key with the following value:

```
logicAppURL
```
Next add your Logic App endpoint that you copied into the value field, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/logicapp1.png)

Click Save. Click on 'Overview' and press the 'Restart' button. See below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/restartwebapp.png)

#### Now we can test the Web app <--> Logic App connectivity

Navigate to your web site, select 'Order now' on your coffee of choice, enter an email address and select 'Place Order'. An Order Confirmation message will be displayed on your website. Now we can navigate to the Logic App to see if our web site sent it a request - all triggered runs history can be seen in the 'Overview' section. See below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/logicapprun.png)

You should see a succeeded run which you can drill own to see the inputs, confirm these match what you ordered.

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/webapprun2.png)

You should see the values we sent in the Request Body:
```
{
  "coffeeType": "Espresso",
  "total": "3.75",
  "emailAddress": "bobby@turtlenecksweater.com",
  "preferredLanguage": "Hello there"
}
```
Note: The website is hard coded to send "Hello there" for every order, you can add a field to capture customer comments to the website, we will instead focus on the chat bot as our primary ordering system.

#### Now we can setup and test the chatbot app <--> Logic App connectivity

Navigate back to your Resource Group and select your provisioned Bot Service App Service App, it will have a default name of commcombot3[hash]. Click on Settings in the top menu, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botsettings.png)

Click on 'Open' in the 'Application Settings' section, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botappsettings.png)

You will now be presented with a similar settings screen as with the website, enter a key again with the following value:

```
logicAppURL
```
Next add your Logic App endpoint that you copied into the value field and click Save. You do not need to restart the Bot app. Now in the box that says 'Type your message' enter some text in a language of your choice. You will be prompted for a few answers, enter them and after your order has been confirmed you should see a response as below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/botint1.png)

Now we can navigate to the Logic App to see if our chat bot sent it a request - go back to the Runs History in the 'Overview' section. Inspect the Request Body again - you should now have your chat bot and your web site set up to interact directly with the Logic App. Note: The 'preferredLanguage' value in your Request Body will now hold the first value to entered in the chat bot.

#### Now we want to detect the language that the customer engaged with the chat bot on

We now want to add an action after the request step to start processing what request - this will be a step to detect the language in the preferredLanguage field. Select 'Add an action', see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/logicapp2.png)

Search for the word 'Detect', this should return the option to select the 'Text Analytics - Detect Language' connector.  Note you will need to have your key ready that you got when you signed up for the Text Analytics preview as part of the pre-requisites, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/detectlang.png)

Now we want to pass the value of the preferredLanguage field into the Text input field of this connector. To do this place your cursor inside the Text field and you should see the dynamic content popup appear on the right. Select the 'Body' option, but this will send all field values to the connector whereas we only want 'preferredLanguage'. Open up the code view and amend the json from:
```
"text": "@{triggerBody()}"
```
to
```
 "text": "@{triggerBody()['preferredLanguage']}"
 ```
Click Save. We are now using json dot notation to select the field we want. You can now test your Logic App via the chat bot and see if this works. Greet your bot and order another coffee, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/logicdetect.png)

We can see that we keep getting an 'undefined' message in our chat bot - it is expecting a response, so let's go add the output from the Detect Language step to the Response step, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/detectresp.png)

We can now use this to send a response to our bot, but we now have a json request from the bot, and a json response from the Detect Language connector. Our Serverless proxy is looking for json representing both of these outputs. Here we will do some merging and parsing of these two json messages.

Add an action after the Detect Language step, we want to look for the 'Data Operations - Parse json' connector. We need a schema to represent the fields the Serverless proxy requires, namely:

```
{   "emailAddress": "bobby@turtlenecksweater.com",
    "preferredLanguage": "French",
    "product": "Latte",
    "total", "$3,45"
}
```
We can generate a json schema online - I have used https://jsonschema.net/#/editor which has generated the following schema I can use:
```
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "properties": {
    "emailAddress": {
      "type": "string"
    },
    "preferredLanguage": {
      "type": "string"
    },
    "product": {
      "type": "string"
    },
    "total": {
      "type": "string"
    }
  },
  "required": [
    "emailAddress",
    "total",
    "product",
    "preferredLanguage"
  ],
  "type": "object"
}
```
Now comes the tricky bit, we will need to go into the code view to go and formulate the json manually so that we can populate this schema from our Request Body and Detect Language outputs. My code view for this step looks like this (you might want to copy this if string manipulation makes you go cross-eyed):
```
            "Parse_JSON": {
                "inputs": {
                    "content": "{'emailAddress': '@{triggerBody()['emailAddress']}' , 'product': '@{triggerBody()['coffeeType']}' , 'total': '@{triggerBody()['total']}' , 'preferredLanguage': '@{body('Detect_Language')?['detectedLanguages'][0]['name']}'}",
                    "schema": {}
                },
                "runAfter": {
                    "Detect_Language": [
                        "Succeeded"
                    ]
                },
                "type": "ParseJson"
            },
```

You can now run another test to see if your parse json conforms to the schema. Once it does you are ready to now pass the new json message to the Serverless proxy to pass to the legacy database. 

Note, the Logic App designer will state that the json is invalid while the code view will think it is valid, it this happens ensure that you always click save in the code view whenever you make a change! See below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/parseJson.png)

Now we want to call our Serverless proxy - method 'AddNewCustomerOrder', see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/neworder.png)

And if our schema is good then all we have to do is pass it the Body of the Parse Json step, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/parsebody.png)

This will now register the user in our database alongside their preferred language for future communication. Why don't we send them a confirmation of their order in the preferred language? To do this search for 'Translate' and add the 'Microsoft Translator - Translate Text' connector, see below:

![alt text](https://github.com/shanepeckham/CADScenario_Personalisation/blob/master/images/translate.png)

Now as inputs you want to send it the preferredLanguage contents again and the target language. 












 
 































Navigating back to the designer should show your values resolved like below:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/querycontactsbyid.png)

Now you need to query the Legacy Ticket API (Contacts Case List API) which is inside the isolated network to get the last case for that customer and retrieve the customer's feedback on the case. From the demo model hint above you want to use the caseNum field from the QueryContactsById to query the Legacy Ticket API field primary key field CaseId.

Add an API Management API step, select the Contact Case List API and once again query by Id, which in this CaseId which maps to the caseNum output from the previous step and add the API Management subscription key.

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/querycasesbyid.png)

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/querycasesselectidmethod.png)

Ensure you select the correct outputs from the previous step(s) as inputs to this step, see below:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/querycasebycasenum.png)

Now if you applied the logic from the previous step to select the correct outut field values (which would be a sensible approach) you will probably get the following error:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/querycaseserror.png)

This is due to us outputting an array but not specifying which record/index we want to use. Change the following line from
```
"id": "@{encodeURIComponent(body('QueryContactsById')?['caseNum'])}"
```
to use the first value of the array, namely the 0 index:

```
  "id": "@{encodeURIComponent(body('QueryContactsById')[0]['caseNum'])}"
```

Here is what your code view should look like for this step:
```
            "QueryCasesById": {
                "inputs": {
                    "api": {
                        "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/[ResourceGroup]/providers/Microsoft.ApiManagement/service/cadapimxdb3o43h6p7bq/apis/58cd5516dc78ac0f84da1289"
                    },
                    "method": "get",
                    "pathTemplate": {
                        "parameters": {
                            "id": "@{encodeURIComponent(body('QueryContactsById')[0]['caseNum'])}"
                        },
                        "template": "/LegacyAPI/contacts/{id}"
                    },
                    "subscriptionKey": "@{triggerBody()['APIMKey']}"
                },
                "runAfter": {
                    "QueryContactsById": [
                        "Succeeded"
                    ]
                },
                "type": "ApiManagement"
            },
```

Now we want to add our Cognitive Services 'Detect Sentiment' (note you will need to have your key ready that you got when you signed up for the Text Analytics preview as part of the pre-requisites) step  so that we can analyse the sentiment of the Ticket Feedback:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/searchdetect.png)

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/selectsentiment.png)

We now need to make sure we send the correct output from the QueryCasesById step to the Detect Sentiment step, use the javascript dot notation approach again with an index value. Your steps should look like this:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/lastfeedback.png)

Your code view should look like this:
```
            "Detect_Sentiment": {
                "inputs": {
                    "body": {
                        "text": "@{body('QueryCasesById')?['last_feedback']}"
                    },
                    "host": {
                        "api": {
                            "runtimeUrl": "https://logic-apis-northeurope.azure-apim.net/apim/cognitiveservicestextanalytics"
                        },
                        "connection": {
                            "name": "@parameters('$connections')['cognitiveservicestextanalytics']['connectionId']"
                        }
                    },
                    "method": "post",
                    "path": "/sentiment"
                },
                "runAfter": {
                    "QueryCasesById": [
                        "Succeeded"
                    ]
                },
                "type": "ApiConnection"
            },
```

Now we want to add a condition to check the sentiment, if the probability outcome is less than 0.5, then it negative sentiment and therefore qualifies for our discount coupon.

Your condition should look like this:

![alt text](https://github.com/shanepeckham/CADHackathon_Loyalty/blob/master/Images/Condition.jpg)

With the following in code view:
```
"expression": "@less(body('Detect_Sentiment')?['score'], 0.5)",
                        "runAfter": {
                            "Detect_Sentiment": [
                                "Succeeded"
                            ]
                        },
                        "type": "If"

```

Now you can call the GenerateCoupon function if the condition is met, pass in the name of the user that you want to generate the digital coupon for:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/ifcondition0.png)

With the following in the code view:
```
"GenerateCoupon": {
                        "inputs": {
                            "body": {
                                "name": "@body('QueryContactsById')[0]['name']"
                            },
                            "function": {
                                "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/NewLoyaltyPlan/providers/Microsoft.Web/sites/CADFuncxdb3o43h6p7bq/functions/GenerateCoupon"
                            }
                        },
                        "runAfter": {},
                        "type": "Function"
                    }
                },
```
Now we want to send an email to every receipient to inform them that they can download a digital coupon which we have generated for them.

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/selectgmail.png)

Your email step should look like this:

![alt text](https://github.com/shanepeckham/CADLab_Loyalty/blob/master/Images/sendemail.png)

With the following code view:
```
                    "Send_email": {
                        "inputs": {
                            "body": {
                                "Body": "Please accept this coupon: @{body('GenerateCoupon')}",
                                "Subject": "We heard that you were not happy",
                                "To": "@{body('QueryContactsById')[0]['email']}"
                            },
                            "host": {
                                "api": {
                                    "runtimeUrl": "https://logic-apis-northeurope.azure-apim.net/apim/gmail"
                                },
                                "connection": {
                                    "name": "@parameters('$connections')['gmail']['connectionId']"
                                }
                            },
                            "method": "post",
                            "path": "/Mail"
                        },
                        "runAfter": {
                            "GenerateCoupon": [
                                "Succeeded"
                            ]
                        },
                        "type": "ApiConnection"
                    }
```

The full code solution view looks like this:
```
{
    "$connections": {
        "value": {
            "cognitiveservicestextanalytics": {
                "connectionId": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/NewLoyaltyPlan/providers/Microsoft.Web/connections/cognitiveservicestextanalytics",
                "connectionName": "cognitiveservicestextanalytics",
                "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/providers/Microsoft.Web/locations/northeurope/managedApis/cognitiveservicestextanalytics"
            },
            "gmail": {
                "connectionId": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/NewLoyaltyPlan/providers/Microsoft.Web/connections/gmail",
                "connectionName": "gmail",
                "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/providers/Microsoft.Web/locations/northeurope/managedApis/gmail"
            }
        }
    },
    "definition": {
        "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
        "actions": {
            "Condition": {
                "actions": {
                    "GenerateCoupon": {
                        "inputs": {
                            "body": {
                                "name": "@body('QueryContactsById')[0]['name']"
                            },
                            "function": {
                                "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/NewLoyaltyPlan/providers/Microsoft.Web/sites/CADFuncxdb3o43h6p7bq/functions/GenerateCoupon"
                            }
                        },
                        "runAfter": {},
                        "type": "Function"
                    },
                    "Send_email": {
                        "inputs": {
                            "body": {
                                "Body": "Please accept this coupon: @{body('GenerateCoupon')}",
                                "Subject": "We heard that you were not happy",
                                "To": "@{body('QueryContactsById')[0]['email']}"
                            },
                            "host": {
                                "api": {
                                    "runtimeUrl": "https://logic-apis-northeurope.azure-apim.net/apim/gmail"
                                },
                                "connection": {
                                    "name": "@parameters('$connections')['gmail']['connectionId']"
                                }
                            },
                            "method": "post",
                            "path": "/Mail"
                        },
                        "runAfter": {
                            "GenerateCoupon": [
                                "Succeeded"
                            ]
                        },
                        "type": "ApiConnection"
                    }
                },
                "expression": "@less(body('Detect_Sentiment')?['score'], 0.5)",
                "runAfter": {
                    "Detect_Sentiment": [
                        "Succeeded"
                    ]
                },
                "type": "If"
            },
            "Detect_Sentiment": {
                "inputs": {
                    "body": {
                        "text": "@{body('QueryCasesById')?['last_feedback']}"
                    },
                    "host": {
                        "api": {
                            "runtimeUrl": "https://logic-apis-northeurope.azure-apim.net/apim/cognitiveservicestextanalytics"
                        },
                        "connection": {
                            "name": "@parameters('$connections')['cognitiveservicestextanalytics']['connectionId']"
                        }
                    },
                    "method": "post",
                    "path": "/sentiment"
                },
                "runAfter": {
                    "QueryCasesById": [
                        "Succeeded"
                    ]
                },
                "type": "ApiConnection"
            },
            "QueryCasesById": {
                "inputs": {
                    "api": {
                        "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/NewLoyaltyPlan/providers/Microsoft.ApiManagement/service/cadapimxdb3o43h6p7bq/apis/58cd5516dc78ac0f84da1289"
                    },
                    "method": "get",
                    "pathTemplate": {
                        "parameters": {
                            "id": "@{encodeURIComponent(body('QueryContactsById')[0]['caseNum'])}"
                        },
                        "template": "/LegacyAPI/contacts/{id}"
                    },
                    "subscriptionKey": "@{triggerBody()['APIMKey']}"
                },
                "runAfter": {
                    "QueryContactsById": [
                        "Succeeded"
                    ]
                },
                "type": "ApiManagement"
            },
            "QueryContactsById": {
                "inputs": {
                    "api": {
                        "id": "/subscriptions/1b987fd6-b38e-40a1-bca8-4f67e6272c12/resourceGroups/NewLoyaltyPlan/providers/Microsoft.ApiManagement/service/cadapimxdb3o43h6p7bq/apis/58cd4c45dc78ac0f84da1287"
                    },
                    "method": "get",
                    "pathTemplate": {
                        "parameters": {
                            "id": "@{encodeURIComponent(triggerBody()['id'])}"
                        },
                        "template": "/Contacts/contacts/{id}"
                    },
                    "subscriptionKey": "@{triggerBody()['APIMKey']}"
                },
                "runAfter": {},
                "type": "ApiManagement"
            }
        },
        "contentVersion": "1.0.0.0",
        "outputs": {},
        "parameters": {
            "$connections": {
                "defaultValue": {},
                "type": "Object"
            }
        },
        "triggers": {
            "manual": {
                "inputs": {
                    "schema": {}
                },
                "kind": "Http",
                "type": "Request"
            }
        }
    }
}

```
# Troubleshooting

If you get and 'Internal Server Error' 500 on the Contact Case List (Legacy Ticket API) this could be because the node API has stopped. ssh into the VM and navigate to the /LegacyAPI/CADContacts folder and run 'node server.js'. 
e.g.

```cd LegacyAPI 
cd CADContacts
node server.js
```
