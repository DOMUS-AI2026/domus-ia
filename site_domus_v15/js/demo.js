/* DOMUS AI · simulador da página Demonstração */
(function(){
  const $=id=>document.getElementById(id);
  const feed=$('feed'),log=$('log'),auto=$('auto');
  if(!feed) return;
  const state={leak:false,valveOpen:true,light:false,ac:false,timers:[]};
  const now=()=>new Date().toTimeString().slice(0,8);
  function tick(){$('clock').textContent=new Date().toTimeString().slice(0,5)}
  tick();setInterval(tick,15000);
  function L(msg,c){const s=document.createElement('span');s.innerHTML='<span class="c">['+now()+']</span> '+(c?'<span class="'+c+'">'+msg+'</span>':msg);log.appendChild(s);log.scrollTop=log.scrollHeight}
  function pill(id,txt,cls){const e=$(id);e.textContent=txt;e.className='pill '+cls}
  function later(fn,ms){state.timers.push(setTimeout(fn,ms))}
  function lit(n){['p1','p2','p3'].forEach((p,i)=>$(p).classList.toggle('lit',i<n))}
  function power(){const kw=0.4+(state.light?0.1:0)+(state.ac?1.2:0);$('kPow').textContent=kw.toFixed(1).replace('.',',')+' kW'}
  function clearEmpty(){const e=feed.querySelector('.empty');if(e)e.remove()}
  function note(kind,title,text,actionLabel,onAct){
    clearEmpty();
    const n=document.createElement('div');n.className='note '+kind;
    n.innerHTML='<div class="top"><span>'+title+'</span><span>agora</span></div><p>'+text+'</p><div class="act"></div>';
    const a=n.querySelector('.act');
    if(actionLabel){
      const b=document.createElement('button');b.type='button';b.textContent=actionLabel;
      const g=document.createElement('button');g.type='button';g.className='ghost';g.textContent='Ignorar';
      b.onclick=()=>onAct(n);g.onclick=()=>{done(n,'Alerta ignorado');L('Usuário ignorou o alerta','w');lit(0)};
      a.append(b,g);
    }
    feed.prepend(n);return n;
  }
  function done(n,msg){n.classList.remove('crit','warn');n.classList.add('done');n.querySelector('.act').innerHTML='<span class="res">✓ '+msg+'</span>'}
  /* no celular, rola até o app para a pessoa ver o alerta chegar */
  function showPhone(){if(window.matchMedia('(max-width:920px)').matches){$('phone').scrollIntoView({behavior:'smooth',block:'start'})}}

  function act(n,automatic,cmd,confirm,apply,msg){
    lit(3);L('DOMUS → '+cmd,'c');
    later(()=>{apply();L(confirm,'o');done(n,automatic?msg+' automaticamente':msg);later(()=>lit(0),1200)},900);
  }
  function scenario(o){
    lit(1);o.start();L(o.sensorLog,o.sensorCls);
    later(()=>{lit(2);L(o.analysis);showPhone();
      const n=note(o.kind,o.title,o.text,auto.checked?null:o.action,n=>o.resolve(n,false));
      if(auto.checked){L('Modo automático ativo: DOMUS vai agir sem esperar');later(()=>o.resolve(n,true),700)}
      else L('Notificação enviada. Aguardando aprovação do usuário');
    },800);
  }

  $('bLeak').onclick=()=>{
    if(state.leak||!state.valveOpen){L('Reinicie a simulação para testar o vazamento de novo','w');return}
    state.leak=true;
    scenario({kind:'crit',title:'Alerta · Água',text:'Possível vazamento detectado no banheiro.',action:'Fechar registro',
      start:()=>{pill('waterS','Água detectada','crit');$('kWater').textContent='96 L/h'},
      sensorLog:'Sensor de água (banheiro): água no piso · consumo +700%',sensorCls:'x',
      analysis:'DOMUS: padrão de vazamento identificado',
      resolve:(n,a)=>act(n,a,'válvula do banheiro: FECHAR','Válvula confirmou: registro fechado',
        ()=>{state.valveOpen=false;state.leak=false;pill('valveS','Fechada','crit');pill('waterS','Úmido','warn');$('kWater').textContent='0 L/h'},'Registro fechado')});
  };
  $('bLight').onclick=()=>{
    if(state.light){L('A luz da sala já está ligada. Resolva o alerta ou reinicie','w');return}
    state.light=true;
    scenario({kind:'warn',title:'Aviso · Energia',text:'Luz da sala ligada há 2 horas sem presença detectada.',action:'Desligar luz',
      start:()=>{pill('lightS','Ligada · 2h','warn');pill('presS','Vazio','idle');power()},
      sensorLog:'Relé da sala: luz ligada há 2h · presença: nenhuma',sensorCls:'w',
      analysis:'DOMUS: consumo desnecessário identificado',
      resolve:(n,a)=>act(n,a,'relé da sala: DESLIGAR','Relé confirmou: luz da sala desligada',
        ()=>{state.light=false;pill('lightS','Desligada','idle');power()},'Luz desligada')});
  };
  $('bAc').onclick=()=>{
    if(state.ac){L('O ar do quarto já está ligado. Resolva o alerta ou reinicie','w');return}
    state.ac=true;
    scenario({kind:'warn',title:'Aviso · Climatização',text:'Ar-condicionado do quarto ligado há 2 horas e ninguém no ambiente.',action:'Desligar ar',
      start:()=>{pill('acS','Ligado · 2h','warn');pill('pres2S','Vazio','idle');power()},
      sensorLog:'Tomada do quarto: ar ligado há 2h · presença: nenhuma',sensorCls:'w',
      analysis:'DOMUS: climatização em ambiente vazio',
      resolve:(n,a)=>act(n,a,'tomada inteligente do quarto: DESLIGAR','Tomada confirmou: ar-condicionado desligado',
        ()=>{state.ac=false;pill('acS','Desligado','idle');power()},'Ar desligado')});
  };
  $('bReset').onclick=()=>{
    state.timers.forEach(clearTimeout);state.timers=[];
    Object.assign(state,{leak:false,valveOpen:true,light:false,ac:false});
    pill('waterS','Seco','ok');pill('valveS','Aberta','ok');pill('presS','Vazio','idle');pill('lightS','Desligada','idle');
    pill('pres2S','Vazio','idle');pill('acS','Desligado','idle');
    $('kWater').textContent='12 L/h';power();lit(0);
    feed.innerHTML='<p class="empty">Tudo certo por aqui.<br>Nenhum alerta ativo.</p>';
    log.innerHTML='';L('Simulação reiniciada. Todos os sensores normais','o');
  };
  auto.onchange=()=>L('Modo automático '+(auto.checked?'ativado: o DOMUS executa a ação sozinho':'desativado: o DOMUS pede sua aprovação'));
  L('DOMUS online · 6 dispositivos conectados','o');
})();
