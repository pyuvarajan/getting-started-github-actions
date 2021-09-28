<div class="px-4 py-5 text-center">![SONiC logo](https://azure.github.io/SONiC/pdf/newsletters/newsletter_images/sonic-logo_40percentage.png)

<div class="col-lg-6 mx-auto">**Latest successful build image in each branch**</div>

</div>

<div class="list-group" id="builds">

<section id="mu-page-breadcrumb">

<div class="container">

<div class="row">

<div style="text-align: center;">

<div style="background-color: lightblue;  ">

<div class="col-md-12">

<div class="mu-page-breadcrumb-area">## SONiC Platform Builds</div>

</div>

</div>

</div>

</div>

</div>

</section>

<table style="width:1200px" border="2" align="center" id="disp_table">

<tbody>

<tr id="branch">

<td style="width: 20%; text-align: center; padding-left: 0.5em; background-color: lightblue; height: 45px; align: center;"><span style="letter-spacing: 0.15em;  font-weight: bold; font-size: calc(11px + 0.6vw); ">Platform</span></td>

</tr>

</tbody>

</table>

</div>

<div class="px-4 text-center">

<div class="col-lg-6 mx-auto">[click here](https://sonic-build.azurewebsites.net/ui/sonic/Pipelines) for previous builds Contact: <a href="">GitHub</a></div>

</div>

<script>$(document).ready(function () { $.getJSON("kvsk_f3.json", function(data) { dbs = data; branches = Object.keys(data); image_data = []; for (let i = 0; i < branches.length; i++) { display_data = "<td style=\" text-align: center; padding-left: 0.5em; background-color: lightblue; height: 45px; align: center;\"><span style=\"letter-spacing: 0.15em; font-weight: bold; font-size: calc(11px + 0.6vw); \">" + branches[i].toUpperCase() +"</span></td>"; $("#branch").append(display_data); images = Object.keys(data[branches[i]]); for (let j = 0; j < images.length; j++) { image_name = images[j]; image = data[branches[i]][images[j]]; image_platform = image_name.split(".")[0]; if(image_platform.length == 1){ platform = "" }else{ platform = image_platform.split("sonic-")[1]; if(platform.length == 1){ platform = "" } } image_avail = true; image_url = image['url']; if(image_url === 'null' || image_url === ""){ image_avail = false; } if ( !$("#"+platform).length ){ platform_column = "<tr id=\""+ platform +"\"><td style=\" text-align: center; \"><strong>"+ platform.toUpperCase()+"</strong></td></tr>"; $("#disp_table").append(platform_column); } if (image_avail) image_column ="<td style=\"text-align: center;\"><span style=\"color: #0000ff;\"><a href=\""+ image_url +"\">"+image_name+"</a></span></td>"; else image_column ="<td style=\"text-align: center;\"><span style=\"color: #0000ff;\">N/A</span></td>"; $("#"+platform).append(image_column); } } }); });</script>
