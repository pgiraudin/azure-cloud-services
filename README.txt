First, please copy the <LocalResources> and <Startup> tags from the ServiceDefinition.csdef file to the one of the CloudService solution. We're providing the whole .csdef file here as it might help you in finding out where those tags exactly belong.
For finding out the TENANT and TOKEN parameters, go to your dashboard, open the menu and select "Monitor another host" and "Linux".
The download URL that's displayed there contains both of them. The first part of the URL (eg. dwypaxjjgx) is the TENANT parameter. The last part (eg. kSL7jGRsdIfc9mab) is the TOKEN.

Then, please copy the setupRuxit.cmd and Install.ps1 files into your WebRole project. Open the properties of those files then and make sure that "Build Action" is set to "Embedded Resource" and "Copy to output directory" is set to "Copy always".

