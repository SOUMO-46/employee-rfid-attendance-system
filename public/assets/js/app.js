document.addEventListener('DOMContentLoaded',()=>{
 const sidebar=document.getElementById('sidebar'),menu=document.getElementById('menuBtn');
 menu?.addEventListener('click',()=>sidebar?.classList.toggle('open'));
 document.querySelectorAll('[data-confirm]').forEach(el=>el.addEventListener('click',e=>{if(!confirm(el.dataset.confirm))e.preventDefault()}));
 document.querySelectorAll('[data-auto-submit]').forEach(el=>el.addEventListener('change',()=>el.form.submit()));
 document.querySelectorAll('.btn-primary').forEach(btn=>btn.addEventListener('click',()=>{btn.classList.add('pressed');setTimeout(()=>btn.classList.remove('pressed'),180)}));
 if(!window.matchMedia('(prefers-reduced-motion: reduce)').matches){
   document.querySelectorAll('.metric').forEach(el=>{const target=Number(el.textContent.trim());if(!Number.isFinite(target)||target<1)return;let n=0,step=Math.max(1,Math.ceil(target/22));const tick=()=>{n=Math.min(target,n+step);el.textContent=n;if(n<target)requestAnimationFrame(tick)};el.textContent='0';requestAnimationFrame(tick)});
 }
 const employee=document.getElementById('employee'),basic=document.getElementById('basic');
 const syncSalary=()=>{if(employee&&basic){basic.value=employee.options[employee.selectedIndex]?.dataset.salary||0}};
 employee?.addEventListener('change',syncSalary); syncSalary();
});
