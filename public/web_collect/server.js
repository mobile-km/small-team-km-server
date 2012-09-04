(function(k, n, o, m) {
  var a = k["PIN_Ku3Abc6h"] = {
    w: k,
    d: n,
    n: o,
    a: m,
    html_doms: {},
    f: function() {
      return {
        callback: [],
        kill: function(b) {
          if (typeof b === "string") b = document.getElementById(b);
          b && b.parentNode && b.parentNode.removeChild(b)
        },
        get: function(b, c) {
          var d = null;
          return d = typeof b[c] === "string" ? b[c] : b.getAttribute(c)
        },
        set: function(b, c, d) {
          if (typeof b[c] === "string") b[c] = d;
          else b.setAttribute(c, d)
        },
        make: function(b) {
          var c = false,
          d, e;
          for (d in b) if (b[d].hasOwnProperty) {
            c = document.createElement(d);
            for (e in b[d]) b[d][e].hasOwnProperty && typeof b[d][e] === "string" && collector.funcs.set(c, e, b[d][e]);
            break
          }
          return c
        },
        listen: function(b, c, d) {
          if (typeof window.addEventListener !== "undefined") b.addEventListener(c, d, false);
          else typeof window.attachEvent !== "undefined" && b.attachEvent("on" + c, d)
        },
        getSelection: function() {
          return ("" + (window.getSelection ? window.getSelection() : document.getSelection ? document.getSelection() : document.selection.createRange().text)).replace(/(^\s+|\s+$)/g, "")
        },
        pin: function(b) {
          var c = collector.options.pin + "?",
          d = "false",
          e = collector.funcs.get(b, "pinImg"),
          g = collector.funcs.get(b, "pinUrl") || document.URL,
          f = collector.vars.selectedText || collector.funcs.get(b, "pinDesc") || document.title;
          g = g.split("#")[0];
          if (b.rel === "video") d = "true";
          c = c + "media=" + encodeURIComponent(e);
          c = c + "&url=" + encodeURIComponent(g);
          c = c + "&title=" + encodeURIComponent(document.title.substr(0, 500));
          c = c + "&is_video=" + d;
          c = c + "&description=" + encodeURIComponent(f.substr(0, 500));
          if (collector.vars.inlineHandler) c = c + "&via=" + encodeURIComponent(document.URL);
          if (collector.vars.hazIOS) {
            window.setTimeout(function() {
              window.location = "pinit12://" + c
            },
            25);
            window.location = "http://" + c
          } else window.open("http://" + c, "pin" + (new Date).getTime(), collector.options.pop)
        },
        close: function(b) {
          if (collector.html_doms.bg) {
            document.body.removeChild(collector.html_doms.shim);
            document.body.removeChild(collector.html_doms.bg);
            document.body.removeChild(collector.html_doms.bd)
          }
          window.is_collecting_now = false;
          b && window.alert(b);
          collector.vars.hazGoodUrl = false;
          window.scroll(0, collector.vars.saveScrollTop)
        },
        click: function(b) {
          b = b || window.event;
          var c = null;
          if (c = b.target ? b.target.nodeType === 3 ? b.target.parentNode: b.target: b.srcElement) if (c === collector.html_doms.x) collector.funcs.close();
          else if (c.className !== collector.options.k + "_hideMe") if (c.className === collector.options.k + "_pinThis") {
            collector.funcs.pin(c);
            window.setTimeout(function() {
              collector.funcs.close()
            },
            10)
          }
        },
        keydown: function(b) { ((b || window.event).keyCode || null) === 27 && collector.funcs.close()
        },
        behavior: function() {
          collector.funcs.listen(collector.html_doms.bd, "click", collector.funcs.click);
          collector.funcs.listen(document, "keydown", collector.funcs.keydown)
        },
        add_css_to_page: function() {
          var b = collector.funcs.make({
            STYLE: {
              type: "text/css"
            }
          }),
          c = collector.options.cdn[window.location.protocol] || collector.options.cdn["http:"],
          d = collector.options.rules.join("\n");
          d = d.replace(/#_/g, "#" + "PIN_Ku3Abc6h" + "_");
          d = d.replace(/\._/g, "." + "PIN_Ku3Abc6h" + "_");
          d = d.replace(/_cdn/g, c);
          if (b.styleSheet) b.styleSheet.cssText = d;
          else b.appendChild(document.createTextNode(d));
          document.head ? document.head.appendChild(b) : document.body.appendChild(b)
        },
        addThumb: function(b, c, d) { (d = b.getElementsByTagName(d)[0]) ? b.insertBefore(c, d) : b.appendChild(c)
        },
        thumb: function(b) {
          if (b.src) {
            if (!b.media) b.media = "image";
            var c = collector.options.k + "_thumb_" + b.src,
            d = collector.funcs.make({
              SPAN: {
                className: collector.options.k + "_pinContainer"
              }
            }),
            e = collector.funcs.make({
              A: {
                className: collector.options.k + "_pinThis",
                rel: b.media,
                href: "#"
              }
            }),
            g = collector.funcs.make({
              SPAN: {
                className: "img"
              }
            }),
            f = new Image;
            collector.funcs.set(f, "nopin", "nopin");
            b.page && collector.funcs.set(e, "pinUrl", b.page);
            if (collector.vars.canonicalTitle || b.title) collector.funcs.set(e, "pinDesc", collector.vars.canonicalTitle || b.title);
            b.desc && collector.funcs.set(e, "pinDesc", b.desc);
            f.style.visibility = "hidden";
            f.onload = function() {
              var i = this.width,
              h = this.height;
              if (h === i) this.width = this.height = collector.options.thumbCellSize;
              if (h > i) {
                this.width = collector.options.thumbCellSize;
                this.height = collector.options.thumbCellSize * (h / i);
                this.style.marginTop = 0 - (this.height - collector.options.thumbCellSize) / 2 + "px"
              }
              if (h < i) {
                this.height = collector.options.thumbCellSize;
                this.width = collector.options.thumbCellSize * (i / h);
                this.style.marginLeft = 0 - (this.width - collector.options.thumbCellSize) / 2 + "px"
              }
              this.style.visibility = ""
            };
            f.src = b.thumb ? b.thumb: b.src;
            collector.funcs.set(e, "pinImg", b.src);
            if (b.extended) f.className = "extended";
            g.appendChild(f);
            d.appendChild(g);
            b.media !== "image" && d.appendChild(collector.funcs.make({
              SPAN: {
                className: collector.options.k + "_play"
              }
            }));
            g = collector.funcs.make({
              CITE: {}
            });
            g.appendChild(collector.funcs.make({
              span: {
                className: collector.options.k + "_mask"
              }
            }));
            f = b.height + " x " + b.width;
            if (b.duration) {
              f = b.duration % 60;
              if (f < 10) f = "0" + f;
              f = ~~ (b.duration / 60) + ":" + f
            }
            if (b.total_slides) f = b.total_slides + " slides";
            f = collector.funcs.make({
              span: {
                innerHTML: f
              }
            });
            if (b.provider) f.className = collector.options.k + "_" + b.provider;
            g.appendChild(f);
            d.appendChild(g);
            d.appendChild(e);
            e = false;
            if (b.dupe) {
              g = 0;
              for (f = collector.vars.thumbed.length; g < f; g += 1) if (collector.vars.thumbed[g].id.indexOf(b.dupe) !== -1) {
                e = collector.vars.thumbed[g].id;
                break
              }
            }
            if (e !== false) {
              if (e = document.getElementById(e)) {
                e.parentNode.insertBefore(d, e);
                e.parentNode.removeChild(e)
              } else {
                b.page || b.media !== "image" ? collector.funcs.addThumb(collector.html_doms.embedContainer, d, "SPAN") : collector.funcs.addThumb(collector.html_doms.imgContainer, d, "SPAN");
              }
            } else {
              collector.html_doms.imgContainer.appendChild(d);
              collector.vars.hazAtLeastOneGoodThumb += 1
            } 

            (b = document.getElementById(c)) && b.parentNode.removeChild(b);


            d.id = c;
            collector.funcs.set(d, "domain", c.split("/")[2]);
            collector.vars.thumbed.push(d)
          }
        },
        call: function(b, c) {
          var d = collector.funcs.callback.length,
          e = collector.options.k + ".f.callback[" + d + "]",
          g = document.createElement("SCRIPT");
          collector.funcs.callback[d] = function(f) {
            c(f, d);
            collector.vars.awaitingCallbacks -= 1;
            collector.funcs.kill(e)
          };
          g.id = e;
          g.src = b + "&callback=" + e;
          g.type = "text/javascript";
          g.charset = "utf-8";
          collector.vars.firstScript.parentNode.insertBefore(g, collector.vars.firstScript);
          collector.vars.awaitingCallbacks += 1
        },
        ping: {
          checkDomain: function(b) {
            var c, d;
            if (b && b.disallowed_domains && b.disallowed_domains.length) {
              c = 0;
              for (d = b.disallowed_domains.length; c < d; c += 1) if (b.disallowed_domains[c] === window.location.host) {
                collector.funcs.close(collector.options.msg.noPin);
                return
              } else collector.vars.badDomain[b.disallowed_domains[c]] = true;
              c = 0;
              for (d = collector.vars.thumbed.length; c < d; c += 1) collector.vars.badDomain[collector.funcs.get(collector.vars.thumbed[c], "domain")] === true && collector.funcs.unThumb(collector.vars.thumbed[c].id.split("thumb_").pop())
            }
          },
          info: function(b) {
            if (b) if (b.err) collector.funcs.unThumb(b.id);
            else if (b.reply && b.reply.img && b.reply.img.src) {
              var c = "";
              if (b.reply.page) c = b.reply.page;
              if (b.reply.nopin && b.reply.nopin === 1) collector.funcs.unThumb(b.id);
              else {
                if (collector.vars.scragAllThumbs === true) {
                  collector.html_doms.embedContainer.innerHTML = "";
                  collector.html_doms.imgContainer.innerHTML = ""
                }
                collector.funcs.thumb({
                  provider: b.src,
                  src: b.reply.img.src,
                  height: b.reply.img.height,
                  width: b.reply.img.width,
                  media: b.reply.media,
                  desc: b.reply.description,
                  page: c,
                  duration: b.reply.duration || 0,
                  total_slides: b.reply.total_slides || 0,
                  dupe: b.id
                })
              }
            }
          }
        },
        unThumb: function(b) {
          b = collector.options.k + "_thumb_" + b;
          var c = document.getElementById(b);
          if (c) {
            if (collector.vars.canonicalImage) if (collector.options.k + "_thumb_" + collector.vars.canonicalImage === b) return;
            b = c.getElementsByTagName("A")[0];
            b.className = collector.options.k + "_hideMe";
            b.innerHTML = collector.options.msg.grayOut;
            collector.vars.hazAtLeastOneGoodThumb -= 1
          }
        },
        getExtendedInfo: function(b) {
          if (!collector.vars.hazCalledForInfo[b]) {
            collector.vars.hazCalledForInfo[b] = true;
            collector.funcs.call(collector.options.embed + b, collector.funcs.ping.info)
          }
        },
        getId: function(b) {
          for (var c, d = b.u.split("?")[0].split("#")[0].split("/"); ! c;) c = d.pop();
          if (b.r) c = parseInt(c, b.r);
          return encodeURIComponent(c)
        },
        seekCanonical: function(b) {
          var c = collector.options.seek[b],
          d = null,
          e = null,
          g,
          f,
          i,
          h,
          l,
          j = {
            pPrice: "",
            pCurrencySymbol: ""
          };
          if (!c || !c.via) return null;
          if (typeof c.via === "string" && a.collector.varsia[c.via]) d = a.collector.varsia[c.via];
          else if (typeof c.via === "object") d = c.via;
          g = collector.vars[d.tagName] || document.getElementsByTagName(d.tagName);
          l = g.length;
          for (h = 0; h < l; h += 1) {
            f = collector.funcs.get(g[h], d.property);
            if ((i = collector.funcs.get(g[h], d.content)) && f) if (d.field[f]) j[d.field[f]] = i
          }
          if (j.pId && j.pId !== c.id) return null;
          if (j.pUrl && j.pImg) {
            e = new Image;
            e.onload = function() {
              collector.funcs.thumb({
                media: c.media || "image",
                provider: b,
                src: this.src,
                title: this.title,
                height: this.height,
                width: this.width
              });
              collector.vars.tag.push(e)
            };
            collector.vars.canonicalTitle = j.pTitle || document.title;
            if (c.fixTitle) if (collector.vars.canonicalTitle.match(c.fixTitle.find)) {
              collector.vars.canonicalTitle = collector.vars.canonicalTitle.replace(c.fixTitle.find, c.fixTitle.replace);
              if (c.fixTitle.suffix) collector.vars.canonicalTitle += c.fixTitle.suffix
            }
            collector.vars.canonicalTitle = collector.vars.canonicalTitle.replace(/%s%/, j.pCurrencySymbol + j.pPrice);
            e.title = collector.vars.canonicalTitle;
            e.setAttribute("page", j.pUrl);
            if (c.fixImg) if (j.pImg.match(c.fixImg.find)) j.pImg = j.pImg.replace(c.fixImg.find, c.fixImg.replace);
            if (c.checkNonCanonicalImages) collector.vars.checkNonCanonicalImages = true;
            collector.vars.canonicalImage = e.src = j.pImg;
            return e
          }
          return null
        },
        hazUrl: {
          etsy: function() {
            collector.funcs.seekCanonical("etsy")
          },
          fivehundredpx: function() {
            var b = collector.funcs.seekCanonical("fivehundredpx");
            if (b) {
              b.setAttribute("extended", true);
              b.setAttribute("dupe", b.src);
              collector.funcs.getExtendedInfo("src=fivehundredpx&id=" + encodeURIComponent(b.src))
            }
          },
          flickr: function() {
            var b = collector.funcs.seekCanonical("flickr");
            if (b) {
              b.setAttribute("extended", true);
              b.setAttribute("dupe", b.src);
              collector.funcs.getExtendedInfo("src=flickr&id=" + encodeURIComponent(b.src))
            }
          },
          kickstarter: function() {
            collector.funcs.seekCanonical("kickstarter")
          },
          soundcloud: function() {
            var b = collector.funcs.seekCanonical("soundcloud");
            if (b) {
              b.setAttribute("extended", true);
              collector.vars.scragAllThumbs = true;
              collector.funcs.getExtendedInfo("src=soundcloud&id=" + encodeURIComponent(document.URL.split("?")[0].split("#")[0]))
            }
          },
          slideshare: function() {
            var b = collector.funcs.seekCanonical("slideshare");
            if (b) {
              b.setAttribute("extended", true);
              collector.vars.scragAllThumbs = true;
              collector.funcs.getExtendedInfo("src=slideshare&id=" + encodeURIComponent(document.URL.split("?")[0].split("#")[0]))
            }
          },
          youtube: function() {
            var b = collector.funcs.seekCanonical("youtube");
            if (b) {
              b.setAttribute("extended", true);
              collector.funcs.getExtendedInfo("src=youtube&id=" + encodeURIComponent(b.getAttribute("page").split("=")[1].split("&")[0]))
            }
          },
          vimeo: function() {
            var b = collector.funcs.getId({
              u: document.URL,
              r: 10
            }),
            c = "vimeo";
            if (window.location.protocol === "https:") c += "_s";
            b > 1E3 && collector.funcs.getExtendedInfo("src=" + c + "&id=" + b)
          },
          googleImages: function() {
            collector.vars.inlineHandler = "google"
          },
          tumblr: function() {
            collector.vars.inlineHandler = "tumblr"
          },
          netflix: function() {
            collector.vars.inlineHandler = "netflix"
          },
          pinterest: function() {
            collector.funcs.close(collector.options.msg.installed)
          },
          facebook: function() {
            collector.funcs.close(collector.options.msg.privateDomain.replace(/%privateDomain%/, "Facebook"))
          },
          googleReader: function() {
            collector.funcs.close(collector.options.msg.privateDomain.replace(/%privateDomain%/, "Google Reader"))
          },
          stumbleUpon: function() {
            var b = 0,
            c = collector.options.stumbleFrame.length,
            d;
            for (b = 0; b < c; b += 1) if (d = document.getElementById(collector.options.stumbleFrame[b])) {
              collector.funcs.close();
              if (window.confirm(collector.options.msg.bustFrame)) window.location = d.src;
              break
            }
          }
        },
        hazSite: {
          flickr: {
            img: function(b) {
              if (b.src) {
                b.src = b.src.split("?")[0];
                collector.funcs.getExtendedInfo("src=flickr&id=" + encodeURIComponent(b.src))
              }
            }
          },
          fivehundredpx: {
            img: function(b) {
              if (b.src) {
                b.src = b.src.split("?")[0];
                collector.funcs.getExtendedInfo("src=fivehundredpx&id=" + encodeURIComponent(b.src))
              }
            }
          },
          behance: {
            img: function(b) {
              if (b.src) {
                b.src = b.src.split("?")[0];
                collector.funcs.getExtendedInfo("src=behance&id=" + encodeURIComponent(b.src))
              }
            }
          },
          netflix: {
            img: function(b) {
              if (b = b.src.split("?")[0].split("#")[0].split("/").pop()) {
                id = parseInt(b.split(".")[0]);
                id > 1E3 && collector.vars.inlineHandler && collector.vars.inlineHandler === "netflix" && collector.funcs.getExtendedInfo("src=netflix&id=" + id)
              }
            }
          },
          youtube: {
            img: function(b) {
              b = b.src.split("?")[0].split("#")[0].split("/");
              b.pop();
              (id = b.pop()) && collector.funcs.getExtendedInfo("src=youtube&id=" + id)
            },
            iframe: function(b) { (b = collector.funcs.getId({
                u: b.src
              })) && collector.funcs.getExtendedInfo("src=youtube&id=" + b)
            },
            video: function(b) { (b = collector.funcs.get(b, "data-youtube-id")) && collector.funcs.getExtendedInfo("src=youtube&id=" + b)
            },
            embed: function(b) {
              var c = collector.funcs.get(b, "flashvars"),
              d = "";
              if (c) {
                if (d = c.split("video_id=")[1]) d = d.split("&")[0];
                d = encodeURIComponent(d)
              } else d = collector.funcs.getId({
                u: b.src
              });
              d && collector.funcs.getExtendedInfo("src=youtube&id=" + d)
            },
            object: function(b) {
              b = collector.funcs.get(b, "data");
              var c = "";
              if (b)(c = collector.funcs.getId({
                u: b
              })) && collector.funcs.getExtendedInfo("src=youtube&id=" + c)
            }
          },
          vimeo: {
            iframe: function(b) {
              b = collector.funcs.getId({
                u: b.src,
                r: 10
              });
              b > 1E3 && collector.funcs.getExtendedInfo("src=vimeo&id=" + b)
            }
          }
        },
        parse: function(b, c) {
          b = b.split(c);
          if (b[1]) return b[1].split("&")[0];
          return ""
        },
        handleInline: {
          google: function(b) {
            if (b) {
              var c, d = 0,
              e = 0,
              g = collector.funcs.get(b, "src");
              if (g) {
                e = b.parentNode;
                if (e.tagName === "A" && e.href) {
                  b = collector.funcs.parse(e.href, "&imgrefurl=");
                  c = collector.funcs.parse(e.href, "&imgurl=");
                  d = parseInt(collector.funcs.parse(e.href, "&w="));
                  e = parseInt(collector.funcs.parse(e.href, "&h="));
                  c && g && b && e > collector.options.minImgSize && d > collector.options.minImgSize && collector.funcs.thumb({
                    thumb: g,
                    src: c,
                    page: b,
                    height: e,
                    width: d
                  });
                  collector.vars.check_this_domain[c.split("/")[2]] = true
                }
              }
            }
          },
          tumblr: function(b) {
            var c = [];
            c = null;
            c = "";
            if (b.src) {
              for (c = b.parentNode; c.tagName !== "LI" && c !== document.body;) c = c.parentNode;
              if (c.tagName === "LI" && c.parentNode.id === "posts") {
                c = c.getElementsByTagName("A");
                (c = c[c.length - 1]) && c.href && collector.funcs.thumb({
                  src: b.src,
                  page: c.href,
                  height: b.height,
                  width: b.width
                })
              }
            }
          }
        },
        hazTag: {
          img: function(b) {
            if (collector.vars.inlineHandler && typeof collector.funcs.handleInline[collector.vars.inlineHandler] === "function") collector.funcs.handleInline[collector.vars.inlineHandler](b);
            else if (!b.src.match(/^data/)) {
              if (b.height > collector.options.minImgSize && b.width > collector.options.minImgSize) {
                if (b.parentNode.tagName === "A" && b.parentNode.href) {
                  var c = b.parentNode,
                  d = c.href.split(".").pop().split("?")[0].split("#")[0];
                  if (d === "gif" || d === "jpg" || d === "jpeg" || d === "png") {
                    d = new Image;
                    d.onload = function() {
                      collector.funcs.thumb({
                        src: this.src,
                        height: this.height,
                        width: this.width,
                        title: this.title,
                        dupe: this.getAttribute("dupe")
                      })
                    };
                    d.title = c.title || c.alt || b.title || b.alt;
                    d.src = c.href;
                    d.setAttribute("dupe", b.src)
                  }
                }
                collector.funcs.thumb({
                  src: b.src,
                  height: b.height,
                  width: b.width,
                  title: b.title || b.alt
                })
              }
              collector.vars.check_this_domain[b.src.split("/")[2]] = true
            }
          }
        },
        checkTags: function() {
          var b, c, d, e, g, f, i, h, l;
          b = 0;
          for (c = collector.options.check.length; b < c; b += 1) {
            g = document.getElementsByTagName(collector.options.check[b]);
            d = 0;
            for (e = g.length; d < e; d += 1) {
              f = g[d]; ! collector.funcs.get(f, "nopin") && f.style.display !== "none" && f.style.visibility !== "hidden" && collector.vars.tag.push(f)
            }
          }
          b = 0;
          for (c = collector.vars.tag.length; b < c; b += 1) {
            g = collector.vars.tag[b];
            f = g.tagName.toLowerCase();
            if (collector.options.tag[f]) for (i in collector.options.tag[f]) if (collector.options.tag[f][i].hasOwnProperty) {
              h = collector.options.tag[f][i];
              if (l = collector.funcs.get(g, h.att)) {
                d = 0;
                for (e = h.match.length; d < e; d += 1) l.match(h.match[d]) && collector.funcs.hazSite[i][f](g)
              }
            }
            collector.funcs.hazTag[f] && collector.funcs.hazTag[f](g)
          }
          collector.funcs.checkDomainBlacklist()
        },
        getHeight: function() {
          return Math.max(
            Math.max(document.body.scrollHeight, document.scrollHeight), 
            Math.max(document.body.offsetHeight, document.offsetHeight), 
            Math.max(document.body.clientHeight, document.clientHeight)
          )
        },
        structure: function() {
          collector.html_doms.shim = collector.funcs.make({
            IFRAME: {
              height: "100%",
              width: "100%",
              allowTransparency: true,
              id: collector.options.k + "_shim"
            }
          });
          collector.funcs.set(collector.html_doms.shim, "nopin", "nopin");
          document.body.appendChild(collector.html_doms.shim);
          collector.html_doms.bg = collector.funcs.make({
            DIV: {
              id: collector.options.k + "_bg"
            }
          });
          document.body.appendChild(collector.html_doms.bg);
          collector.html_doms.bd = collector.funcs.make({
            DIV: {
              id: collector.options.k + "_bd"
            }
          });
          collector.html_doms.bd.appendChild(collector.funcs.make({
            DIV: {
              id: collector.options.k + "_spacer"
            }
          }));
          collector.html_doms.hd = collector.funcs.make({
            DIV: {
              id: collector.options.k + "_hd"
            }
          });
          collector.html_doms.hd.appendChild(collector.funcs.make({
            SPAN: {
              id: collector.options.k + "_logo"
            }
          }));
          collector.html_doms.x = collector.funcs.make({
            A: {
              id: collector.options.k + "_x",
              innerHTML: collector.options.msg.cancelTitle
            }
          });
          collector.html_doms.hd.appendChild(collector.html_doms.x);
          collector.html_doms.bd.appendChild(collector.html_doms.hd);
          collector.html_doms.embedContainer = collector.funcs.make({
            SPAN: {
              id: collector.options.k + "_embedContainer"
            }
          });
          collector.html_doms.bd.appendChild(collector.html_doms.embedContainer);
          collector.html_doms.imgContainer = collector.funcs.make({
            SPAN: {
              id: collector.options.k + "_imgContainer"
            }
          });
          collector.html_doms.bd.appendChild(collector.html_doms.imgContainer);
          document.body.appendChild(collector.html_doms.bd);
          var b = collector.funcs.getHeight();
          if (collector.html_doms.bd.offsetHeight < b) {
            collector.html_doms.bd.style.height = b + "px";
            collector.html_doms.bg.style.height = b + "px";
            collector.html_doms.shim.style.height = b + "px"
          }
          window.scroll(0, 0)
        },
        checkUrl: function() {
          var url;

          for (url in collector.options.special_urls) 
            if (collector.options.special_urls[url].hasOwnProperty) 
              if (document.URL.match(collector.options.special_urls[url])) {
                collector.funcs.hazUrl[url]();
                if (collector.vars.hazGoodUrl === false) return false
              }

          return true
        },
        checkPage: function() {
          if (collector.funcs.checkUrl()) {
            if (!collector.vars.canonicalImage || collector.vars.checkNonCanonicalImages) 
              collector.funcs.checkTags();
            if (collector.vars.hazGoodUrl === false) return false
          } else return false;
          return true
        },
        checkDomainBlacklist: function() {
          var b = collector.options.checkDomain.url + "?domains=",
          c, d = 0;
          for (c in collector.vars.check_this_domain) if (collector.vars.check_this_domain[c].hasOwnProperty && !collector.vars.check_domain_done[c]) {
            collector.vars.check_domain_done[c] = true;
            if (d) b += ",";
            d += 1;
            b += encodeURIComponent(c);
            if (d > collector.options.maxCheckCount) {
              collector.funcs.call(b, collector.funcs.ping.checkDomain);
              b = collector.options.checkDomain.url + "?domains=";
              d = 0
            }
          }
          d > 0 && collector.funcs.call(b, collector.funcs.ping.checkDomain)
        },
        foundNoPinMeta: function() {
          var b, c, d;
          d = collector.vars.meta.length;
          for (c = 0; c < d; c += 1) {
            b = collector.vars.meta[c];
            if (b.name && b.name.toUpperCase() === "PINTEREST" && b.content && b.content.toUpperCase() === "NOPIN") {
              if (b = collector.funcs.get(b, "description")) {
                d = "The owner of the site";
                c = document.URL.split("/");
                if (c[2]) d = c[2];
                collector.funcs.close(collector.options.msg.noPinReason.replace(/%s%/, d) + "\n\n" + b)
              } else collector.funcs.close(collector.options.msg.noPin);
              return true
            }
          }
        },
        init: function() {
          document = documentocumentElement;
          document.body = document.getElementsByTagName("BODY")[0];
          document.head = document.getElementsByTagName("HEAD")[0];
          if (document.body) {
            if (window.is_collecting_now !== true) {
              window.is_collecting_now = true;
              var b = a.n.userAgent;
              collector.vars = {
                saveScrollTop: window.pageYOffset,
                hazGoodUrl: true,
                hazAtLeastOneGoodThumb: 0,
                awaitingCallbacks: 0,
                thumbed: [],
                hazIE: function() {
                  return /msie/i.test(b) && !/opera/i.test(b)
                } (),
                hazIOS: function() {
                  return b.match(/iP/) !== null
                } (),
                firstScript: document.getElementsByTagName("SCRIPT")[0],
                selectedText: collector.funcs.getSelection(),
                hazCalledForInfo: {},
                check_this_domain: {},
                check_domain_done: {},
                badDomain: {},
                meta: document.getElementsByTagName("META"),
                tag: [],
                canonicalTitle: ""
              };
              if (!collector.funcs.foundNoPinMeta()) {
                collector.vars.check_this_domain[window.location.host] = true;
                collector.funcs.checkDomainBlacklist();
                collector.funcs.add_css_to_page();
                collector.funcs.structure();
                if (collector.funcs.checkPage()) if (collector.vars.hazGoodUrl === true) {
                  collector.funcs.behavior();
                  if (collector.funcs.callback.length > 1) collector.vars.waitForCallbacks = window.setInterval(function() {
                    if (collector.vars.awaitingCallbacks === 0) if (collector.vars.hazAtLeastOneGoodThumb === 0 || collector.vars.tag.length === 0) {
                      window.clearInterval(collector.vars.waitForCallbacks);
                      collector.funcs.close(collector.options.msg.notFound)
                    }
                  },
                  500);
                  else if (!collector.vars.canonicalImage && (collector.vars.hazAtLeastOneGoodThumb === 0 || collector.vars.tag.length === 0)) collector.funcs.close(collector.options.msg.notFound)
                }
              }
            }
          } else collector.funcs.close(collector.options.msg.noPinIncompletePage)
        }
      }
    } ()
  };
  collector.funcs.init()
})(window, document, navigator, {
  k: "PIN_Ku3Abc6h",
  checkDomain: {
    url: "//api.pinterest.com/v2/domains/filter_nopin/"
  },
  cdn: {
    "https:": "https://a248.e.akamai.net/passets.pinterest.com.s3.amazonaws.com",
    "http:": "http://passets-cdn.pinterest.com"
  },
  embed: "//pinterest.com/embed/?",
  pin: "pinterest.com/pin/create/bookmarklet/",
  minImgSize: 80,
  maxCheckCount: 20,
  thumbCellSize: 200,
  check: ["meta", "iframe", "embed", "object", "img", "video", "a"],
  special_urls: {
    fivehundredpx: /^https?:\/\/500px\.com\/photo\//,
    etsy: /^https?:\/\/.*?\.etsy\.com\/listing\//,
    facebook: /^https?:\/\/.*?\.facebook\.com\//,
    flickr: /^https?:\/\/www\.flickr\.com\//,
    googleImages: /^https?:\/\/.*?\.google\.com\/search/,
    googleReader: /^https?:\/\/.*?\.google\.com\/reader\//,
    kickstarter: /^https?:\/\/.*?\.kickstarter\.com\/projects\//,
    netflix: /^https?:\/\/.*?\.netflix\.com/,
    pinterest: /^https?:\/\/.*?\.?pinterest\.com\//,
    slideshare: /^https?:\/\/.*?\.slideshare\.net\//,
    soundcloud: /^https?:\/\/soundcloud\.com\//,
    stumbleUpon: /^https?:\/\/.*?\.stumbleupon\.com\//,
    tumblr: /^https?:\/\/www\.tumblr\.com/,
    vimeo: /^https?:\/\/vimeo\.com\//,
    youtube: /^https?:\/\/www\.youtube\.com\/watch\?/
  },
  via: {
    og: {
      tagName: "meta",
      property: "property",
      content: "content",
      field: {
        "og:type": "pId",
        "og:url": "pUrl",
        "og:image": "pImg"
      }
    }
  },
  seek: {
    etsy: {
      id: "etsymarketplace:item",
      via: {
        tagName: "meta",
        property: "property",
        content: "content",
        field: {
          "og:title": "pTitle",
          "og:type": "pId",
          "og:url": "pUrl",
          "og:image": "pImg",
          "etsymarketplace:price_value": "pPrice",
          "etsymarketplace:currency_symbol": "pCurrencySymbol"
        }
      },
      fixImg: {
        find: /_570xN/,
        replace: "_fullxfull"
      },
      fixTitle: {
        suffix: ". %s%, via Etsy."
      },
      checkNonCanonicalImages: true
    },
    fivehundredpx: {
      id: "five_hundred_pixels:photo",
      via: "og",
      fixImg: {
        find: /\/3.jpg/,
        replace: "/4.jpg"
      },
      fixTitle: {
        find: /^500px \/ Photo /,
        replace: "",
        suffix: ", via 500px."
      }
    },
    flickr: {
      via: {
        tagName: "link",
        property: "rel",
        content: "href",
        field: {
          canonical: "pUrl",
          image_src: "pImg"
        }
      },
      fixImg: {
        find: /_m.jpg/,
        replace: "_z.jpg"
      },
      fixTitle: {
        find: / \| Flickr(.*)$/,
        replace: "",
        suffix: ", via Flickr."
      }
    },
    kickstarter: {
      id: "kickstarter:project",
      via: "og",
      media: "video",
      fixTitle: {
        find: / \u2014 Kickstarter$/,
        replace: "",
        suffix: ", via Kickstarter."
      }
    },
    slideshare: {
      id: "slideshare:add_css_to_page",
      via: "og",
      media: "video"
    },
    soundcloud: {
      id: "soundcloud:sound",
      via: "og",
      media: "video",
      fixTitle: {
        find: / on SoundCloud(.*)$/,
        replace: "",
        suffix: ", via SoundCloud."
      }
    },
    youtube: {
      id: "video",
      via: "og",
      fixTitle: {
        find: / - YouTube$/,
        replace: "",
        suffix: ", via YouTube."
      }
    }
  },
  stumbleFrame: ["tb-stumble-frame", "stumbleFrame"],
  tag: {
    img: {
      flickr: {
        att: "src",
        match: [/staticflickr.com/, /static.flickr.com/]
      },
      fivehundredpx: {
        att: "src",
        match: [/pcdn\.500px\.net/]
      },
      behance: {
        att: "src",
        match: [/^http:\/\/behance\.vo\.llnwd\.net/]
      },
      netflix: {
        att: "src",
        match: [/^http:\/\/cdn-?[0-9]\.nflximg\.com/, /^http?s:\/\/netflix\.hs\.llnwd\.net/]
      },
      youtube: {
        att: "src",
        match: [/ytimg.com\/vi/, /img.youtube.com\/vi/]
      }
    },
    video: {
      youtube: {
        att: "src",
        match: [/videoplayback/]
      }
    },
    embed: {
      youtube: {
        att: "src",
        match: [/^http:\/\/s\.ytimg\.com\/yt/, /^http:\/\/.*?\.?youtube-nocookie\.com\/v/]
      }
    },
    iframe: {
      youtube: {
        att: "src",
        match: [/^http:\/\/www\.youtube\.com\/embed\/([a-zA-Z0-9\-_]+)/]
      },
      vimeo: {
        att: "src",
        match: [/^http?s:\/\/vimeo.com\/(\d+)/, /^http:\/\/player\.vimeo\.com\/video\/(\d+)/]
      }
    },
    object: {
      youtube: {
        att: "data",
        match: [/^http:\/\/.*?\.?youtube-nocookie\.com\/v/]
      }
    }
  },
  msg: {
    check: "",
    cancelTitle: "Cancel",
    grayOut: "Sorry, cannot pin this image.",
    noPinIncompletePage: "Sorry, can't pin from non-HTML pages. If you're trying to upload an image, please visit pinterest.com.",
    bustFrame: "We need to hide the StumbleUpon toolbar to Pin from this page.  After pinning, you can use the back button in your browser to return to StumbleUpon. Click OK to continue or Cancel to stay here.",
    noPin: "Sorry, pinning is not allowed from this domain. Please contact the site operator if you have any questions.",
    noPinReason: "Pinning is not allowed from this page.\n\n%s% provided the following reason:",
    privateDomain: "Sorry, can't pin directly from %privateDomain%.",
    notFound: "Sorry, couldn't find any pinnable images or video on this page.",
    installed: "The bookmarklet is installed! Now you can click your Pin It button to pin images as you browse sites around the web."
  },
  pop: "status=no,resizable=yes,scrollbars=yes,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,width=632,height=270,left=0,top=0",
  rules: ["#_shim {z-index:2147483640; position: absolute; background: transparent; top:0; right:0; bottom:0; left:0; width: 100%; border: 0;}", "#_bg {z-index:2147483641; position: absolute; top:0; right:0; bottom:0; left:0; background-color:#f2f2f2; opacity:.95; width: 100%; }", "#_bd {z-index:2147483642; position: absolute; text-align: center; width: 100%; top: 0; left: 0; right: 0; font:16px hevetica neue,arial,san-serif; }", "#_bd #_hd { z-index:2147483643; -moz-box-shadow: 0 1px 2px #aaa; -webkit-box-shadow: 0 1px 2px #aaa; box-shadow: 0 1px 2px #aaa; position: fixed; *position:absolute; width:100%; top: 0; left: 0; right: 0; height: 45px; line-height: 45px; font-size: 14px; font-weight: bold; display: block; margin: 0; background: #fbf7f7; border-bottom: 1px solid #aaa; }", "#_bd #_hd a#_x { display: inline-block; cursor: pointer; color: #524D4D; line-height: 45px; text-shadow: 0 1px #fff; float: right; text-align: center; width: 100px; border-left: 1px solid #aaa; }", "#_bd #_hd a#_x:hover { color: #524D4D; background: #e1dfdf; text-decoration: none; }", "#_bd #_hd a#_x:active { color: #fff; background: #cb2027; text-decoration: none; text-shadow:none;}", "#_bd #_hd #_logo {height: 43px; width: 100px; display: inline-block; margin-right: -100px; background: transparent url(_cdn/images/LogoRed.png) 50% 50% no-repeat; border: none;}", "#_bd #_spacer { display: block; height: 50px; }", "#_bd span._pinContainer { height:200px; width:200px; display:inline-block; background:#fff; position:relative; -moz-box-shadow:0 0  2px #555; -webkit-box-shadow: 0 0  2px #555; box-shadow: 0 0  2px #555; margin: 10px; }", "#_bd span._pinContainer { zoom:1; *border: 1px solid #aaa; }", "#_bd span._pinContainer img { margin:0; padding:0; border:none; }", "#_bd span._pinContainer span.img, #_bd span._pinContainer span._play { position: absolute; top: 0; left: 0; height:200px; width:200px; overflow:hidden; }", "#_bd span._pinContainer span._play { background: transparent url(_cdn/images/bm/play.png) 50% 50% no-repeat; }", "#_bd span._pinContainer cite, #_bd span._pinContainer cite span { position: absolute; bottom: 0; left: 0; right: 0; width: 200px; color: #000; height: 22px; line-height: 24px; font-size: 10px; font-style: normal; text-align: center; overflow: hidden; }", "#_bd span._pinContainer cite span._mask { background:#eee; opacity:.75; *filter:alpha(opacity=75); }", "#_bd span._pinContainer cite span._behance { background: transparent url(_cdn/images/attrib/behance.png) 180px 3px no-repeat; }", "#_bd span._pinContainer cite span._flickr { background: transparent url(_cdn/images/attrib/flickr.png) 182px 3px no-repeat; }", "#_bd span._pinContainer cite span._fivehundredpx { background: transparent url(_cdn/images/attrib/fivehundredpx.png) 180px 3px no-repeat; }", "#_bd span._pinContainer cite span._kickstarter { background: transparent url(_cdn/images/attrib/kickstarter.png) 182px 3px no-repeat; }", "#_bd span._pinContainer cite span._slideshare { background: transparent url(_cdn/images/attrib/slideshare.png) 182px 3px no-repeat; }", "#_bd span._pinContainer cite span._soundcloud { background: transparent url(_cdn/images/attrib/soundcloud.png) 182px 3px no-repeat; }", "#_bd span._pinContainer cite span._vimeo { background: transparent url(_cdn/images/attrib/vimeo.png) 180px 3px no-repeat; }", "#_bd span._pinContainer cite span._vimeo_s { background: transparent url(_cdn/images/attrib/vimeo.png) 180px 3px no-repeat; }", "#_bd span._pinContainer cite span._youtube { background: transparent url(_cdn/images/attrib/youtube.png) 180px 3px no-repeat; }", "#_bd span._pinContainer a { text-decoration:none; background:transparent url(_cdn/images/bm/button.png) 60px 300px no-repeat; cursor:pointer; position:absolute; top:0; left:0; height:200px; width:200px; }", "#_bd span._pinContainer a { -moz-transition-property: background-color; -moz-transition-duration: .25s; -webkit-transition-property: background-color; -webkit-transition-duration: .25s; transition-property: background-color; transition-duration: .25s; }", "#_bd span._pinContainer a:hover { background-position: 60px 80px; background-color:rgba(0, 0, 0, 0.5); }", "#_bd span._pinContainer a._hideMe { background: rgba(128, 128, 128, .5); *background: #aaa; *filter:alpha(opacity=75); line-height: 200px; font-size: 10px; color: #fff; text-align: center; font-weight: normal!important; }"]
});