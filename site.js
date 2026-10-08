/* ============================================================
   Glow Cosmetics - site.js
   Chhoti si plain JavaScript (koi library nahi):
   mobile menu, sticky navbar, scroll reveal, counters,
   testimonial slider, FAQ accordion, back-to-top
   ============================================================ */
(function () {
    'use strict';
    var doc = document;

    function onReady(fn) {
        if (doc.readyState !== 'loading') fn();
        else doc.addEventListener('DOMContentLoaded', fn);
    }

    onReady(function () {

        /* ---------- Mobile menu ---------- */
        var toggle = doc.getElementById('navToggle');
        var links = doc.getElementById('navLinks');
        if (toggle && links) {
            toggle.addEventListener('click', function () {
                links.classList.toggle('open');
                toggle.classList.toggle('open');
            });
        }

        /* ---------- Navbar shadow + back to top ---------- */
        var nav = doc.querySelector('.navbar');
        var toTop = doc.getElementById('toTop');

        function onScroll() {
            var y = window.pageYOffset || doc.documentElement.scrollTop || 0;
            if (nav) nav.classList.toggle('scrolled', y > 10);
            if (toTop) toTop.classList.toggle('show', y > 500);
        }
        window.addEventListener('scroll', onScroll, { passive: true });
        onScroll();

        if (toTop) {
            toTop.addEventListener('click', function () {
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });
        }

        /* ---------- Scroll reveal ---------- */
        var revealItems = doc.querySelectorAll('.reveal');
        if ('IntersectionObserver' in window) {
            var revealObs = new IntersectionObserver(function (entries) {
                entries.forEach(function (en) {
                    if (en.isIntersecting) {
                        en.target.classList.add('in');
                        revealObs.unobserve(en.target);
                    }
                });
            }, { threshold: 0.12 });
            Array.prototype.forEach.call(revealItems, function (el) { revealObs.observe(el); });
        } else {
            Array.prototype.forEach.call(revealItems, function (el) { el.classList.add('in'); });
        }

        /* ---------- Animated counters: <span data-count="500" data-suffix="+"> ---------- */
        function runCounter(el) {
            var target = parseFloat(el.getAttribute('data-count')) || 0;
            var suffix = el.getAttribute('data-suffix') || '';
            var decimals = (String(target).indexOf('.') > -1) ? 1 : 0;
            var duration = 1600;
            var start = null;

            function step(ts) {
                if (!start) start = ts;
                var p = Math.min((ts - start) / duration, 1);
                var eased = 1 - Math.pow(1 - p, 3);
                el.textContent = (target * eased).toFixed(decimals) + suffix;
                if (p < 1) window.requestAnimationFrame(step);
            }
            window.requestAnimationFrame(step);
        }

        var counters = doc.querySelectorAll('[data-count]');
        if ('IntersectionObserver' in window) {
            var countObs = new IntersectionObserver(function (entries) {
                entries.forEach(function (en) {
                    if (en.isIntersecting) {
                        runCounter(en.target);
                        countObs.unobserve(en.target);
                    }
                });
            }, { threshold: 0.4 });
            Array.prototype.forEach.call(counters, function (el) { countObs.observe(el); });
        } else {
            Array.prototype.forEach.call(counters, function (el) {
                el.textContent = el.getAttribute('data-count') + (el.getAttribute('data-suffix') || '');
            });
        }

        /* ---------- Testimonial slider ---------- */
        var slider = doc.getElementById('testiSlider');
        if (slider) {
            var slides = slider.querySelectorAll('.testi-slide');
            var dotsBox = doc.getElementById('testiDots');
            var current = 0;
            var timer = null;

            function show(i) {
                current = (i + slides.length) % slides.length;
                Array.prototype.forEach.call(slides, function (s, idx) {
                    s.classList.toggle('active', idx === current);
                });
                if (dotsBox) {
                    Array.prototype.forEach.call(dotsBox.children, function (d, idx) {
                        d.classList.toggle('active', idx === current);
                    });
                }
            }

            if (dotsBox) {
                Array.prototype.forEach.call(slides, function (s, idx) {
                    var dot = doc.createElement('button');
                    dot.type = 'button';
                    dot.className = 'testi-dot';
                    dot.setAttribute('aria-label', 'Show review ' + (idx + 1));
                    dot.addEventListener('click', function () { show(idx); restart(); });
                    dotsBox.appendChild(dot);
                });
            }

            function restart() {
                if (timer) window.clearInterval(timer);
                timer = window.setInterval(function () { show(current + 1); }, 5000);
            }

            slider.addEventListener('mouseenter', function () { if (timer) window.clearInterval(timer); });
            slider.addEventListener('mouseleave', restart);

            show(0);
            restart();
        }

        /* ---------- FAQ accordion ---------- */
        var faqs = doc.querySelectorAll('.faq-item');
        Array.prototype.forEach.call(faqs, function (item) {
            var q = item.querySelector('.faq-q');
            if (!q) return;
            q.addEventListener('click', function () {
                var wasOpen = item.classList.contains('open');
                Array.prototype.forEach.call(faqs, function (other) { other.classList.remove('open'); });
                if (!wasOpen) item.classList.add('open');
            });
        });

        /* ---------- Success alerts apne aap gayab ---------- */
        var okAlerts = doc.querySelectorAll('.alert-success[data-autohide]');
        Array.prototype.forEach.call(okAlerts, function (a) {
            window.setTimeout(function () { a.classList.add('fade-out'); }, 4500);
        });
    });
})();
