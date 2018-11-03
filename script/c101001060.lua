--黄昏の双龍
--Twilight Twin Dragons
--Scripted by Eerie Code
function c101001060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101001060.condition)
	e1:SetTarget(c101001060.target)
	e1:SetOperation(c101001060.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101001060.thcon)
	e2:SetTarget(c101001060.thtg)
	e2:SetOperation(c101001060.thop)
	c:RegisterEffect(e2)
end
function c101001060.cfilter(c)
	return c:IsFaceup() and c:IsCode(101001028)
end
function c101001060.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101001060.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101001060.filter(c)
	return c:IsCode(57774843) and c:IsAbleToHand()
end
function c101001060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101001060.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101001060.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDiscardDeck(tp,4) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101001060.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)	
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
end
function c101001060.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,4,REASON_EFFECT)
	end
end
function c101001060.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x38) 
		and bit.band(r,REASON_EFFECT)~=0
end
function c101001060.thfilter(c)
	return c:IsCode(101001028) and c:IsAbleToHand()
end
function c101001060.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101001060.thfilter(chkc) end
	local rg=Duel.GetDecktopGroup(tp,4)
	if chk==0 then return Duel.IsExistingTarget(c101001060.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and rg:FilterCount(Card.IsAbleToRemove,nil)==4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101001060.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,4,0,0)
end
function c101001060.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local rg=Duel.GetDecktopGroup(tp,4)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
