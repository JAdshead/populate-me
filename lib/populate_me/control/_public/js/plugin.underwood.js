// Copyright (c) 2010-11 Mickael Riga - See MIT_LICENCE for details
// Version 0.2.2
;(function($){$.fn.underwood=function(l){var m={toolbar:"title paragraph bold italic link mailto unlink source",title_block:'<h3>',paragraph_block:'<p>',sanitize:true,css_href:null};var n=$.extend({},m,l);if(document.designMode||document.contentEditable){return this.each(function(){$(this).parents('form').unbind('submit.underwood').bind('submit.underwood',function(){$(this).find('iframe.underwood_iframe').each(function(){disable_design_mode(this,true)})});enable_design_mode($(this))})}function enable_design_mode(a){var b=document.createElement("iframe");b.frameBorder=0;b.frameMargin=0;b.framePadding=0;b.height=200;b.className="underwood_iframe";if(a.attr('name'))b.rel=a.attr('name');a.after(b);var c;if(n.css_href){c="<link rel='stylesheet' href='"+n.css_href+"' type='text/css' media='screen' charset='utf-8' />"}else{c="				<style type='text/css'>				.underwood_frame_body {font-family:sans-serif;font-size:12px;margin:0;padding:10px;}				.underwood_frame_body p {border:1px #DDD solid;padding:2px;}				</style>"}var d=a.val();if($.trim(d)=='')d='<br>';var e="<html><head>"+c+"</head><body class='underwood_frame_body'>"+d+"</body></html>";try_enable_design_mode(b,e,function(){$(b).prevAll('.underwood_toolbar').remove().end().before(toolbar(b));a.remove()})}function try_enable_design_mode(a,b,c){try{a.contentWindow.document.open();a.contentWindow.document.write(b);a.contentWindow.document.close()}catch(error){console.log(error)}if(document.contentEditable){a.contentWindow.document.designMode="On";c();return true}else if(document.designMode!=null){try{a.contentWindow.document.designMode="on";c();return true}catch(error){console.log(error)}}setTimeout(function(){try_enable_design_mode(a,b,c)},250);return false}function toolbar(e){var f=$("<div class='underwood_toolbar'></div>");var g=n.toolbar.split(' ');for(var i in g){var h=g[i];var j=h.charAt(0).toUpperCase()+h.substr(1).toLowerCase();var k="<a href='#' class='underwood_btn underwood_btn_"+h+"' title='"+j+"'>"+j+"</a>";f.append($(k))}$('.underwood_btn_title',f).click(function(){exec_command(e,"formatblock",n.title_block);return false});$('.underwood_btn_paragraph',f).click(function(){exec_command(e,"formatblock",n.paragraph_block);return false});$('.underwood_btn_bold',f).click(function(){exec_command(e,'bold');return false});$('.underwood_btn_italic',f).click(function(){exec_command(e,'italic');return false});$('.underwood_btn_link',f).click(function(){var a=prompt("URL:","http://");var b=confirm('Open in a new window? (press cancel to open in the same window)')?'_blank':'_self';if(a){exec_command(e,'CreateLink',a);var c=e.contentWindow;var d=c.getSelection();d.focusNode.parentNode.target=b}return false});$('.underwood_btn_mailto',f).click(function(){var a='mailto:'+prompt("Email address:");if(a)exec_command(e,'CreateLink',a);return false});$('.underwood_btn_unlink',f).click(function(){exec_command(e,'unlink');return false});$('.underwood_btn_image',f).click(function(){var a=prompt("Image URL:");if(a)exec_command(e,'InsertImage',a);return false});$('.underwood_btn_source',f).click(function(){var a=disable_design_mode(e);var b=$("<a href='#' class='underwood_btn underwood_btn_back'>Back to Rich Text Editor</a>");f.empty().append(b);b.click(function(){enable_design_mode(a);return false}).hover(function(){$(this).css('opacity',0.6)},function(){$(this).css('opacity',1)});return false});$('.underwood_btn',f).hover(function(){$(this).css('opacity',0.6)},function(){$(this).css('opacity',1)});return f}function exec_command(a,b,c){a.contentWindow.focus();try{a.contentWindow.document.execCommand(b,false,c)}catch(e){console.log(e)}a.contentWindow.focus()}function sanitize_this(s){s=n.sanitize?s.replace(/(<\/?font[^>]*>|style=.[^'"]*['"])/g,''):s;return(s.match(/(>|^)[^<]+(<|$)/)||s.match(/<(object|iframe|img)/))?s:''};function disable_design_mode(a,b){var c=a.contentWindow.document.getElementsByTagName("body")[0].innerHTML;if(b==true)var d=$('<input type="hidden" />');else var d=$('<textarea cols="40" rows="10"></textarea>');d.val(sanitize_this(c));t=d.get(0);t.className="underwood_textarea_copy";if(a.rel)t.name=a.rel;$(a).before(d);if(b!=true)$(a).remove();return d}function create_targeted_link(a,b,c){selected=a.contentWindow.document.getSelection().getRangeAt(0);var d=a.contentWindow.document.createElement('a');d.href=b;d.target=c;if(selected.toString()==''){d.innerHTML=b;selected.insertNode(d)}else{selected.surroundContents(d)}}}})(jQuery);
