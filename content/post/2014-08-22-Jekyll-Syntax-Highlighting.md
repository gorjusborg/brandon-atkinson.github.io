---
title: Jekyll Syntax Highlighting
date: 2014-08-22
---

[Jekyll](jekyllrb.com) and github-pages support syntax highlighting using the
pygments library. 

To use it:  

1. include [pygments aware CSS](https://github.com/aahan/pygments-github-style/blob/master/jekyll-github.css) somewhere in your page template
1. put highlight code block, referencing the desired syntax

    {% raw %}
        {% highlight groovy %}
            class GroovyClass {
                def cry() { 
                    println 'Whaaa!'
                }
            }
        {% endhighlight %}
    {% endraw %}

For instance, the code above should appear like the following:

{% highlight groovy %}
class GroovyClass {
    def cry() { 
        println 'Whaaa!'
    }
}
{% endhighlight %}
