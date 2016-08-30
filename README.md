Dynatrace OneAgent for Microsoft Azure Cloud-Services
========================================

Dynatrace is a full-stack application monitoring solution that covers your entire application stack. Learn more on our website http://www.dynatrace.com

Monitoring Azure Cloud-Services
-------------------------------

Azure Cloud-Services gives you the option of deploying and auto scaling applications and services.
You can use our predefined .csdef configuration file to modify the process of deployment by supplying additional resources. 

First, please copy the <LocalResources> and <Startup> tags from the ServiceDefinition.csdef file to the one of the CloudService solution. We're providing the whole .csdef file here as it might help you in finding out where those tags exactly belong.
You only need to adapt the key/value pairs for your ENV_ID and ENV_TOKEN.

You can also find a description on how to retrieve those parameters in our blog post on the Dynatrace Azure VM Extension: https://blog.ruxit.com/azure-monitoring-with-ruxit/

ENV_ID
------------
Your Dynatrace Environment ID is the unique identifier of your ruxit environment. You can find it easily by looking at the URL in your browser when you are logged into your Dynatrace dashboard.

https://{ENV_ID}.live.dynatrace.com

The subdomain {ENV_ID} represents your Environment ID.

ENV_TOKEN
-----------
The token for your Dynatrace environment. You can get your token by following these steps

go to your Dynatrace environment: https://{ENV_ID}.live.dynatrace.com
Click the burger menu in the top left corner and select "Deploy Dynatrace" and then "Start installation"
On the bottom of the page, you'll see "Setting up Azure or Cloud Foundry monitoring?"
Copy environment ID and token and use it in your config

Then, please copy the setupRuxit.cmd and Install.ps1 files into your WebRole project. Open the properties of those files then and make sure that "Build Action" is set to "Embedded Resource" and "Copy to output directory" is set to "Copy always".


CONTACT
-------
If you have any questions, don't hesitate to contact me at @MartinGoodwell on Twitter.
In case of problems, please create an issue on GitHub.
