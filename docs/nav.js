(function(){
  var NAV = [["Overview", [["Index", "index", true]]], ["As-is \u2014 JI Architecture Views", [["System Context (as-is)", "asis/system-context", false], ["Components (as-is)", "asis/components", false]]], ["As-is \u2014 JI Analysis Pack", [["Functional modules (as-is)", "architecture/asis/functional-modules", false], ["Function decomposition (as-is)", "architecture/tobe/analysis/function-decomposition", false], ["JI user types & access catalogue (as-is)", "architecture/tobe/user-types", false], ["Data dependencies (as-is)", "architecture/asis/data-dependencies", false], ["Integration dependencies (as-is)", "architecture/asis/integration-dependencies", false]]], ["As-is \u2014 Payments", [["Payment templates (as-is)", "architecture/asis/payments/payment-templates", false]]], ["As-is \u2014 JI Database Schema", [["Database index", "asis/database/index", false], ["Schema overview", "asis/database/ji_schema_overview", false], ["Judges Profile & Reference", "asis/database/ji_schema_judges-profile", false], ["Working Patterns, Tickets & Stats", "asis/database/ji_schema_judges-patterns", false], ["Absence & Cover Workflow", "asis/database/ji_schema_absence-cover", false], ["Bookings & Sittings", "asis/database/ji_schema_bookings-sittings", false], ["Reference Data", "asis/database/ji_schema_reference-work", false], ["Audit & Cross-cutting", "asis/database/ji_schema_audit-cross-cutting", false], ["Companion reference (triggers, FKs, externals)", "asis/database/ji_schema_companion", false]]]];
  var base = window.__NAV_BASE__ || './';
  var page = window.__PAGE__ || '';
  var root = document.getElementById('nav-root');
  if (!root) return;
  function slug(s){ return s.toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/^-+|-+$/g,''); }
  var h = '<h2 class="site-title"><a href="' + base + 'index.html">JI As-Is Analysis</a></h2>';
  h += '<div class="nav-controls"><button data-nav-action="expand" title="Expand all groups">Expand all</button> <button data-nav-action="collapse" title="Collapse all groups">Collapse all</button></div>';
  NAV.forEach(function(group){
    var name = group[0], items = group[1];
    var isCurrent = items.some(function(it){ return it[1] === page; });
    h += '<details class="nav-group" data-group="' + slug(name) + '"' + (isCurrent ? ' data-current="true" open' : '') + '>';
    h += '<summary>' + name + '</summary><ul>';
    items.forEach(function(it){
      var href = base + it[1] + '.html';
      var cls = (it[1] === page) ? ' class="current"' : '';
      h += '<li><a href="' + href + '"' + cls + '>' + it[0] + '</a></li>';
    });
    h += '</ul></details>';
  });
  root.innerHTML = h;
  // Persist each group's open/closed state; the current page's group stays open on load.
  root.querySelectorAll('details.nav-group').forEach(function(d){
    var key = 'nav-group-' + d.dataset.group;
    if (d.dataset.current !== 'true') {
      var stored = localStorage.getItem(key);
      if (stored === 'open') d.open = true; else if (stored === 'closed') d.open = false;
    }
    d.addEventListener('toggle', function(){ localStorage.setItem(key, d.open ? 'open' : 'closed'); });
  });
  // Preserve the sidebar's scroll position across page navigations.
  // The site is multi-page, so each click reloads the page and re-renders
  // this nav; without this it would reset to the top every time.
  try { var s = sessionStorage.getItem('nav-scroll'); if (s !== null) root.scrollTop = parseInt(s, 10) || 0; } catch (e) {}
  function saveNavScroll(){ try { sessionStorage.setItem('nav-scroll', String(root.scrollTop)); } catch (e) {} }
  root.addEventListener('click', function(e){ if (e.target.closest && e.target.closest('a')) saveNavScroll(); });
  window.addEventListener('pagehide', saveNavScroll);
  // Expand all / Collapse all (sidebar).
  root.querySelectorAll('button[data-nav-action]').forEach(function(b){
    b.addEventListener('click', function(){
      var open = b.dataset.navAction === 'expand';
      root.querySelectorAll('details.nav-group').forEach(function(d){ d.open = open; });
    });
  });
})();
