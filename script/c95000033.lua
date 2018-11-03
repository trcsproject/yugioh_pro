--Gabrion, the Timelord
function c95000033.initial_effect(c)
	c:EnableUnsummonable()
	--no type/attribute/level
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	c:RegisterEffect(e2)
	c:SetStatus(STATUS_NO_LEVEL,true)
	--time token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95000033,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c95000033.sptg)
	e3:SetOperation(c95000033.spop)
	c:RegisterEffect(e3)
end
c95000033.mark=0
function c95000033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c95000033.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95000034,0,0x4011,0,0,0,0,0) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,95000033+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(token)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3)
			local e4=Effect.CreateEffect(token)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e4:SetRange(LOCATION_MZONE)
			e4:SetValue(c95000033.indval)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e4)
			local e5=Effect.CreateEffect(token)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e5:SetValue(1)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e5)
			local e6=Effect.CreateEffect(token)
			e6:SetDescription(aux.Stringid(95000033,1))
			e6:SetCategory(CATEGORY_TODECK)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetCountLimit(1)
			e6:SetCondition(c95000033.tdcon)
			e6:SetTarget(c95000033.tdtg)
			e6:SetOperation(c95000033.tdop)
			e6:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e6)
		end
		if c:IsRelateToEffect(e) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e4:SetRange(LOCATION_MZONE)
			e4:SetValue(c95000033.indval)
			e4:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e5:SetValue(1)
			e5:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e5)
			local e6=Effect.CreateEffect(c)
			e6:SetDescription(aux.Stringid(95000033,1))
			e6:SetCategory(CATEGORY_TODECK)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetCountLimit(1)
			e6:SetCondition(c95000033.tdcon)
			e6:SetTarget(c95000033.tdtg)
			e6:SetOperation(c95000033.tdop)
			e6:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e6)
		end
		Duel.SpecialSummonComplete()
	end
end
function c95000033.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c95000033.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0
end
function c95000033.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c95000033.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
