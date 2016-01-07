### AvPlayer Documentation ###

  * AvPlayer Guides
  * APIs
    1. Flash Vars
    1. Flash API
    1. Javascript API


### Quick Start ###

#### HTML Basic ####

Insert AvPlayer into your page with html codes :

---

```
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="240" height="20">
	<param name="movie" value="../avplayer.swf?link=http://mediaplayer.yahoo.com/example1.mp3" />
	<!--[if !IE]>-->
	<object type="application/x-shockwave-flash" data="../avplayer.swf?link=http://mediaplayer.yahoo.com/example1.mp3" width="240" height="20">
		<!--<![endif]-->
		<p><a href="http://www.adobe.com/go/getflashplayer">To use AvPlayer ,You need get Adobe Flash player first</a></p>
		<!--[if !IE]>-->
	</object>
	<!--<![endif]-->
</object>
```

**View [this Demo](http://allo.ave7.net/lab/avplayer/Demos/player_basic.html)**

---


#### Javascript Basic ####
Insert AvPlayer with 1 line Javascript code :

---

```
<script type="text/javascript">
avplayer.write("http://mediaplayer.yahoo.com/example1.mp3");
</script>
```

**View [this Demo](http://allo.ave7.net/lab/avplayer/Demos/player_js_write.html)**

---