(function(options){
try{

  var collector = {

    options : options,

    html_doms : {},

    funcs : {

      init : function() {
        console.log('init...');

        collector.head = document.getElementsByTagName('head')[0];

        if(document.body){
          if(!window.is_collecting_now){

            window.is_collecting_now = true;

            // var user_agent = navigator.userAgent;

            collector.vars = {
              saved_scroll_top : window.pageYOffset,
              tags : [],
              canonicalTitle: '', //?????
              thumbed: [], //?????
              haz_at_least_one_good_thumb: 0,
              selected_text: collector.funcs.get_selection(),

              // awaitingCallbacks: 0,
              // hazIE: function() {
              //   return /msie/i.test(b) && !/opera/i.test(b)
              // } (),
              // hazIOS: function() {
              //   return b.match(/iP/) !== null
              // } (),
              // firstScript: document.getElementsByTagName("SCRIPT")[0],
              // hazCalledForInfo: {},
              // check_this_domain: {},
              // check_domain_done: {},
              // badDomain: {},
              // meta: document.getElementsByTagName("META"),
            };

            // collector.vars.check_this_domain[window.location.host] = true;
            // // ? collector.funcs.checkDomainBlacklist();

            collector.funcs.add_css();
            collector.funcs.add_doms();

            collector.funcs.check_tags();

            collector.funcs.add_events();

            // if (collector.funcs.callback.length > 1) {
            //   collector.vars.waitForCallbacks = window.setInterval(function() {
            //     if (collector.vars.awaitingCallbacks === 0) {
            //       if (collector.vars.hazAtLeastOneGoodThumb === 0 || collector.vars.tag.length === 0) {
            //         window.clearInterval(collector.vars.waitForCallbacks);
            //         collector.funcs.close(collector.options.strings.can_not_found_image)
            //       }
            //     }
            //   },500);
            // }
            // else if (
            //     !collector.vars.canonicalImage && 
            //     (collector.vars.hazAtLeastOneGoodThumb === 0 || collector.vars.tag.length === 0)
            //   ) {
            //   collector.funcs.close(collector.options.strings.can_not_found_image)
            // }

          }
        } else {
          collector.funcs.close(collector.options.strings.can_not_collect_from_non_html_page);
        }
      },

      check_tags: function() {

        var CTNs = collector.options.check_tag_names;
        var Ts = collector.vars.tags

        for (var i = 0; i < CTNs.length; i++) {
          var tag_name = CTNs[i];
          var doms = document.getElementsByTagName(tag_name);
          for (var j = 0; j < doms.length; j++) {
            var dom = doms[j];
            if(dom.style.display !== 'none' && dom.style.visibility !== 'hidden'){
              Ts.push(dom)
            }
          }
        }

        //console.log(Ts);

        for (var k = 0; k < Ts.length; k++) {
          var tag_dom = Ts[k];
          var tag_name = tag_dom.tagName.toLowerCase();
          if(collector.funcs._haz_tag[tag_name]) {
            collector.funcs._haz_tag[tag_name](tag_dom)
          }
        }
      },

      _haz_tag: {
        img: function(tag_dom) {

          var V = collector.vars;
          var F = collector.funcs;
          var O = collector.options;

          if (tag_dom.height > O.min_img_size && tag_dom.width > O.min_img_size) {

            var parent_dom = tag_dom.parentNode;
            if (parent_dom.tagName === 'A' && parent_dom.href) {
              var image_type = parent_dom.href.split('.').pop().split('?')[0].split('#')[0];

              if (image_type === 'gif' || image_type === 'jpg' || image_type === 'jpeg' || image_type === 'png') {
                var image_dom = new Image;
                image_dom.title = parent_dom.title || parent_dom.alt || tag_dom.title || tag_dom.alt;
                image_dom.src = parent_dom.href;
                image_dom.setAttribute('dupe', tag_dom.src);

                image_dom.onload = function() {
                  F.thumb({
                    src: this.src,
                    height: this.height,
                    width: this.width,
                    title: this.title,
                    dupe: this.getAttribute('dupe')
                  })
                };
              }
            }

            F.thumb({
              src: tag_dom.src,
              height: tag_dom.height,
              width: tag_dom.width,
              title: tag_dom.title || tag_dom.alt
            })
          }

          // var domain = tag_dom.src.split('/')[2];
          // V.check_this_domain[domain] = true;
        }
      },

      thumb: function(hash) {
        var O = collector.options;
        var K = collector.options.key;
        var B = collector.funcs._build_dom;
        var V = collector.vars;
        var F = collector.funcs;
        var D = collector.html_doms;

        if (hash.src) {
          if (!hash.media) hash.media = 'image';

          var thumb_id = K + '_thumb_' + hash.src;

          var container_dom = B('span', {
            'class': K + '_pinContainer'
          });

          var collect_link_dom = B('a', {
            'class': K + '_pinThis',
            rel: hash.media,
            href: '#'
          });

          var img_span_dom = B('span', {
            'class': 'img'
          });
          
          var image_dom = new Image;


          // F.set(image_dom, "nopin", "nopin");
          // hash.page && F.set(collect_link_dom, "pinUrl", hash.page);

          // if (V.canonicalTitle || hash.title) {
          //   F.set(collect_link_dom, 'pinDesc', V.canonicalTitle || hash.title);
          // }

          // hash.desc && F.set(collect_link_dom, "pinDesc", hash.desc);


          image_dom.style.visibility = 'hidden';
          image_dom.onload = function() {
            var w = this.width;
            var h = this.height;

            if (h === w) {
              this.width = this.height = O.thumb_cell_size;
            }

            if (h > w) {
              this.width = O.thumb_cell_size;
              this.height = O.thumb_cell_size * (h / w);
              this.style.marginTop = 0 - (this.height - O.thumb_cell_size) / 2 + 'px'
            }
            if (h < w) {
              this.height = O.thumb_cell_size;
              this.width = O.thumb_cell_size * (w / h);
              this.style.marginLeft = 0 - (this.width - O.thumb_cell_size) / 2 + 'px'
            }

            this.style.visibility = ''
          };

          image_dom.src = hash.thumb ? hash.thumb : hash.src;

          collect_link_dom.setAttribute('pinImg', hash.src);

          img_span_dom.appendChild(image_dom); // ...
          container_dom.appendChild(img_span_dom); // ...

          var cite_dom = B('cite', {}, hash.height + ' x ' + hash.width);

          container_dom.appendChild(cite_dom);
          container_dom.appendChild(collect_link_dom);

          var flag = false;

          // if (hash.dupe) {
          //   g = 0;
          //   for (f = V.thumbed.length; g < f; g += 1) {
          //     if (V.thumbed[g].id.indexOf(hash.dupe) !== -1) {
          //       flag = V.thumbed[g].id;
          //       break
          //     }
          //   }
          // }

          // if (e !== false) {

          //   if (e = document.getElementById(e)) {
          //     e.parentNode.insertBefore(container_dom, e);
          //     e.parentNode.removeChild(e)
          //   } else{ 
          //     hash.page || 
          //     hash.media !== 'image' ? 
          //     collector.funcs.addThumb(collector.html_doms.embedContainer, container_dom, "SPAN") : 
          //     collector.funcs.addThumb(collector.html_doms.imgContainer, container_dom, "SPAN");
          //   } 

          // } else {
            D.imgContainer.appendChild(container_dom);
            V.haz_at_least_one_good_thumb += 1;
          // } 

          var thumb_dom = document.getElementById(thumb_id);
          if(thumb_dom) thumb_dom.parentNode.removeChild(thumb_dom);

          container_dom.id = thumb_id;
          container_dom.setAttribute('domain', thumb_id.split('/')[2]);
          V.thumbed.push(container_dom)
        }
      },

      close : function(msg) {
        console.log('close...')

        if (collector.html_doms.bg) {
          console.log('remove dom...')
          document.body.removeChild(collector.html_doms.shim);
          document.body.removeChild(collector.html_doms.bg);
          document.body.removeChild(collector.html_doms.bd);
        }

        window.is_collecting_now = false;
        if(msg) window.alert(msg);

        window.scroll(0, collector.vars.saved_scroll_top)
      },

      add_css: function() {
        console.log('add css...')

        var B = collector.funcs._build_dom;
        var O = collector.options;
        var K = collector.options.key;

        var css_link_dom = B('style', {
          type : 'text/css'
        });

        var rules_str = O.rules.join("\n")
          .replace(/#_/g, "#" + K + "_")
          .replace(/\._/g, "." + K + "_")
          .replace(/_cdn/g, O.cdn);

        if (css_link_dom.styleSheet) css_link_dom.styleSheet.cssText = rules_str;
        else css_link_dom.appendChild(document.createTextNode(rules_str));

        document.head ? document.head.appendChild(css_link_dom) : document.body.appendChild(css_link_dom)
      },

      add_doms : function() {
        console.log('add doms...');

        var D = collector.html_doms;
        var B = collector.funcs._build_dom;
        var O = collector.options;
        var K = collector.options.key;

        D.shim = B('iframe', {
          height : "100%",
          width : "100%",
          allowTransparency : true,
          id : K + '_shim'
        })
        //collector.funcs.set(D.shim, "nopin", "nopin");
        document.body.appendChild(D.shim);


        D.bg = B('div', {
          id : K + '_bg'
        });
        document.body.appendChild(D.bg);


        D.bd = B('div', {
          id : K + '_bd'
        });

        D.bd.appendChild(B('div', {
          id : K + '_spacer'
        }));

        D.hd = B('div', {
          id : K + '_hd'
        });

        D.hd.appendChild(B('span', {
          id : K + '_logo'
        }));

        D.x = B('A', {
          id : K + '_x'
        }, O.strings.close);

        D.hd.appendChild(D.x);
        D.bd.appendChild(D.hd);

        D.embedContainer = B('span', {
          id : K + '_embedContainer'
        });
        D.bd.appendChild(D.embedContainer);

        D.imgContainer = B('span', {
          id : K + '_imgContainer'
        });
        D.bd.appendChild(D.imgContainer);

        if(collector.vars.selected_text){
          D.textContainer = B('div', {
            id : K + '_textContainer'
          }, [
            B('div', { 'class':'tip' }, collector.options.strings.you_selected_text),
            B('div', { 'class':'text'}, [
              B('span', {}, collector.vars.selected_text),
              B('a', {
                'class': K + '_pinThis',
                href: 'javascript:;'
              })
            ])
          ]);
          D.bd.appendChild(D.textContainer);
        }

        document.body.appendChild(D.bd);

        var height = collector.funcs._get_height();

        console.log(height)

        if (D.bd.offsetHeight < height) {
          D.bd.style.height   = height + 'px';
          D.bg.style.height   = height + 'px';
          D.shim.style.height = height + 'px'
        };

        window.scroll(0, 0);
      },

      // 根据传入的 dom_hash 构造 dom
      _build_dom: function(tag_name, hash, _children) {
        var children = _children || [];

        var dom = document.createElement(tag_name);

        for(var attr in hash){
          var value = hash[attr];
          dom.setAttribute(attr, value)
        }

        if(typeof children == 'string'){
          dom.appendChild(document.createTextNode(children));
        } else {
          for(var i=0; i<children.length; i++){
            var child = children[i];
            if(typeof child == 'string'){
              dom.appendChild(document.createTextNode(child));
            }else{
              dom.appendChild(child);
            }
          }
        }

        return dom;
      },

      _get_height: function() {
        return Math.max(
          Math.max(document.body.scrollHeight, document.documentElement.scrollHeight), 
          Math.max(document.body.offsetHeight, document.documentElement.offsetHeight), 
          Math.max(document.body.clientHeight, document.documentElement.clientHeight)
        )
      },

      add_events: function() {
        var F = collector.funcs;

        F._listen(collector.html_doms.bd, 'click', F._click);
        F._listen(document, 'keydown', F._keydown);
      },

      _listen: function(dom, event, handler) {
        if (typeof window.addEventListener !== 'undefined') dom.addEventListener(event, handler, false);
        else typeof window.attachEvent !== 'undefined' && dom.attachEvent('on' + event, handler);
      },

      _click: function(evt) {
        console.log('mouse clicked bd..');

        var K = collector.options.key;

        evt = evt || window.event;

        var target = evt.target ? evt.target.nodeType === 3 ? evt.target.parentNode : evt.target : evt.srcElement;

        if (target){

          if (target === collector.html_doms.x) collector.funcs.close();
          else if (target.className !== K + '_hideMe'){
            if (target.className === K + '_pinThis') {
              collector.funcs.collect(target);
              window.setTimeout(function() {
                collector.funcs.close()
              },
              10)
            }
          }
        }
      },

      _keydown: function(evt) { 
        // press esc for close
        console.log('ESC pressed..')

        if(((evt || window.event).keyCode || null) === 27) collector.funcs.close();
      },

      collect: function(target_dom) {
        var O = collector.options;
        var F = collector.funcs;

        var request_url = O.pin + '?';

        var img_url  = target_dom.getAttribute('pinImg');
        var page_url = document.URL; //target_dom.getAttribute('pinUrl');
        var page_title = document.title;
        var desc = F.selected_text || document.title; //target_dom.getAttribute('pinDesc');

        page_url = page_url.split("#")[0];

        request_url = request_url + 'media=' + encodeURIComponent(img_url);
        request_url = request_url + '&url=' + encodeURIComponent(page_url);
        request_url = request_url + '&title=' + encodeURIComponent(page_title.substr(0, 500));
        request_url = request_url + '&description=' + encodeURIComponent(desc.substr(0, 500));

        // if (collector.vars.hazIOS) {
        //   window.setTimeout(function() {
        //     window.location = "pinit12://" + c
        //   },
        //   25);
        //   window.location = "http://" + c
        // } else 

        window.open('http://' + request_url, 'pin' + (new Date).getTime(), O.pop_params)
      },

      get_selection: function() {
        return (
          '' + (
            window.getSelection ? window.getSelection() : document.getSelection ? document.getSelection() : document.selection.createRange().text
          )
        ).replace(/(^\s+|\s+$)/g, '')
      },

    }
  };

  collector.funcs.init();

}catch(e){
  console.log(e);
}
})({
  key : 'TEAMKN_' + (new Date).getTime(),

  min_img_size: 80,
  thumb_cell_size: 200,

  //check_tag_names : ["meta", "iframe", "embed", "object", "img", "video", "a"],
  check_tag_names : ['img'],

  pin: '192.168.1.26:2999/collect',

  pop_params: "status=no,resizable=yes,scrollbars=yes,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,width=632,height=270,left=0,top=0",

  strings : {
    close : '关闭',
    can_not_collect_from_non_html_page : '无法从非HTML页面上采集，你可以通过 teamkn.com 在线创建笔记',
    can_not_found_image : '页面上找不到适合采集的图片',
    you_selected_text : '你选择的文字:'
  },

  cdn : 'http://192.168.1.26:2999/web_collect',

  rules : [
    "#_shim {z-index:2147483640; position:absolute; background:transparent; top:0; right:0; bottom:0; left:0; width:100%; border:0;}", 

    "#_bg {z-index:2147483641; position:absolute; top:0; right:0; bottom:0; left:0; background-color:#363537; opacity:.9; width:100%;}", 

    "#_bd {z-index:2147483642; position:absolute; text-align:center; width:100%; top:0; left:0; right:0; font:16px hevetica neue, arial, san-serif;}", 
    "#_bd #_hd { z-index:2147483643; box-shadow:0 0 2px #000; position:fixed; width:100%; top:0; left:0; right:0; height:45px; line-height:45px; font-size:14px; font-weight:bold; display:block; margin:0; background:#222; border-bottom:1px solid #111;}", 

    "#_bd #_hd a#_x { display:inline-block; cursor:pointer; color:#ccc; background:#444; line-height:35px; height:35px; text-shadow:1px 1px 0 rgba(0, 0, 0, 0.2); float:right; text-align:center; width:90px; font-size:14px; font-weight:bold; margin:5px;}", 
    "#_bd #_hd a#_x:hover { color:#fff; background:#848484; text-decoration:none;}", 
    "#_bd #_hd a#_x:active { color:#fff; background:#1888EA; text-decoration:none;}", 

    "#_bd #_hd #_logo {height:43px; width:260px; display:inline-block; margin-right:-100px; background:transparent url(_cdn/images/logo.png) 50% 50% no-repeat; border:none;}", 
    "#_bd #_spacer { display:block; height:50px; }", 

    "#_bd span._pinContainer { height:200px; width:200px; display:inline-block; background:#fff; position:relative; box-shadow:0 0 2px #000; margin:10px; }", 
    "#_bd span._pinContainer img { margin:0; padding:0; border:none; }", 
    "#_bd span._pinContainer span.img, #_bd span._pinContainer span._play { position: absolute; top: 0; left: 0; height:200px; width:200px; overflow:hidden; }", 
    "#_bd span._pinContainer span._play { background: transparent url(_cdn/images/bm/play.png) 50% 50% no-repeat; }", 
    "#_bd span._pinContainer cite { position:absolute; bottom:0; left:0; right:0; width:200px; color:#000; background:rgba(255, 255, 255, 0.6); height:22px; line-height:24px; font-size:10px; font-weight:bold; font-style:normal; text-align:center; overflow:hidden;}", 
    "#_bd span._pinContainer a { text-decoration:none; background:transparent url(_cdn/images/button.png) 60px 300px no-repeat; cursor:pointer; position:absolute; top:0; left:0; height:200px; width:200px; }", 
    "#_bd span._pinContainer a { -moz-transition-property: background-color; -moz-transition-duration: .25s; -webkit-transition-property: background-color; -webkit-transition-duration: .25s; transition-property: background-color; transition-duration: .25s; }", 
    "#_bd span._pinContainer a:hover { background-position: 60px 80px; background-color:rgba(0, 0, 0, 0.5); }", "#_bd span._pinContainer a._hideMe { background: rgba(128, 128, 128, .5); *background: #aaa; *filter:alpha(opacity=75); line-height: 200px; font-size: 10px; color: #fff; text-align: center; font-weight: normal!important; }",

    "#_bd #_textContainer { color:white; background:rgba(0, 0, 0, 0.4); margin:10px 0 0 0; font-size:14px; font-weight:normal; font-style:normal; }",
    "#_bd #_textContainer .tip{ color:white; font-size:12px; font-weight:normal; font-style:normal; line-height:30px; height:30px; background:rgba(0, 0, 0, 0.4); }",
    "#_bd #_textContainer .text{position:relative;}",
    "#_bd #_textContainer .text span{ display:block; color:white; font-size:14px; font-size:14px; font-weight:normal; font-style:normal; line-height:20px; padding:15px; }",
    "#_bd #_textContainer .text a { text-decoration:none; background:transparent url(_cdn/images/button.png) 50% -100px no-repeat; cursor:pointer; position:absolute; top:0; left:0; bottom:0; right:0; }", 
    "#_bd #_textContainer .text a { -moz-transition-property: background-color; -moz-transition-duration: .25s; -webkit-transition-property: background-color; -webkit-transition-duration: .25s; transition-property: background-color; transition-duration: .25s; }", 
    "#_bd #_textContainer .text a:hover { background-position: 50% 50%; background-color:rgba(0, 0, 0, 0.5); }", "#_bd span._pinContainer a._hideMe { background: rgba(128, 128, 128, .5); *background: #aaa; *filter:alpha(opacity=75); line-height: 200px; font-size: 10px; color: #fff; text-align: center; font-weight: normal!important; }",
  ]
});