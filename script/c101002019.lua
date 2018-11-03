--クローラー・レセプター
--Crawler Receptor
--Scripted by Eerie Code
function c101002019.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002019,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101002019)
	e1:SetTarget(c101002019.target)
	e1:SetOperation(c101002019.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002019,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,101002119)
	e2:SetCondition(c101002019.spcon)
	e2:SetTarget(c101002019.sptg)
	e2:SetOperation(c101002019.spop)
	c:RegisterEffect(e2)
end
function c101002019.filter(c)
	return c:IsSetCard(0x204) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101002019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101002019.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101002019.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101002019.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101002019.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c101002019.filter1(c,e,tp)
	return c:IsSetCard(0x204) and not c:IsCode(101002019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101002019.filter2(c,g)
	return g:IsExists(c101002019.filter3,1,c,c:GetCode())
end
function c101002019.filter3(c,code)
	return not c:IsCode(code)
end
function c101002019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
		local g=Duel.GetMatchingGroup(c101002019.filter1,tp,LOCATION_DECK,0,nil,e,tp)
		return g:IsExists(c101002019.filter2,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c101002019.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c101002019.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c101002019.filter2,nil,g)
	if dg:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=dg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.SpecialSummonComplete()
		local g=Group.FromCards(tc1,tc2)
		Duel.ConfirmCards(1-tp,g)
	end
end
