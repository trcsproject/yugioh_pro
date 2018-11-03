--Scripted by Eerie Code
--PSYFrame Gear Beta
function c6430.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--cannot pendulum summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c6430.splimit)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6430,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c6430.condition)
	e1:SetTarget(c6430.target)
	e1:SetOperation(c6430.operation)
	c:RegisterEffect(e1)
end

function c6430.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end

function c6430.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

function c6430.filter(c,e,tp)
	return c:IsCode(6428) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6430.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c6430.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c6430.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6430.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local sg=Group.FromCards(e:GetHandler(),tc)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		sg:KeepAlive()
		tc:RegisterFlagEffect(6430,RESET_EVENT+0x1fe0000,0,1)
		e:GetHandler():RegisterFlagEffect(6430,RESET_EVENT+0x1fe0000,0,1)
		local de=Effect.CreateEffect(e:GetHandler())
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetCode(EVENT_PHASE+PHASE_END)
		de:SetCountLimit(1)
		de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		de:SetLabel(0)
		de:SetLabelObject(sg)
		de:SetCondition(c6430.descon)
		de:SetOperation(c6430.desop)
		Duel.RegisterEffect(de,tp)
		if Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==2 then
			local at=Duel.GetAttacker()
			if at and at:IsFaceup() then
				Duel.Destroy(at,REASON_EFFECT)
				Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
			end
		end
	end
end

function c6430.descon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local b=false
	local tc=tg:GetFirst()
	while tc and not b do
	  b=tc:GetFlagEffect(6430)==0
		tc=tg:GetNext()
	end
	return Duel.GetTurnCount()~=e:GetLabel() and not b
end
function c6430.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end