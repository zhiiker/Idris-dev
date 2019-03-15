module Control.Algebra.Laws

import Prelude.Algebra as A
import Control.Algebra
import Interfaces.Verified


inverseNeutralIsNeutral : VerifiedGroup t => inverse (the t A.neutral) = A.neutral
inverseNeutralIsNeutral {t} =
    let zero = the t neutral in
    let step1 = cong {f = (<+> inverse zero)} (the (zero = zero) Refl) in
    let step2 = replace {P = \x => zero <+> inverse zero = x} (groupInverseIsInverseL zero) step1 in
    replace {P = \x => x = neutral} (monoidNeutralIsNeutralR $ inverse zero) step2

inverseSquaredIsIdentity : VerifiedGroup t => (x : t) -> inverse (inverse x) = x
inverseSquaredIsIdentity {t} x =
    let zero = the t neutral in
    let step1 = cong {f = (x <+>)} (groupInverseIsInverseL (inverse x)) in
    let step2 = replace {P = \r => r = x <+> neutral} (semigroupOpIsAssociative x (inverse x) (inverse $ inverse x)) step1 in
    let step3 = replace {P = \r => r <+> inverse (inverse x) = x <+> neutral} (groupInverseIsInverseL x) step2 in
    let step4 = replace {P = \r => r = x <+> neutral} (monoidNeutralIsNeutralR (inverse $ inverse x)) step3 in
    replace {P = \r => inverse (inverse x) = r} (monoidNeutralIsNeutralL x) step4

inverseDistributesOverGroupOp : VerifiedAbelianGroup t => (l, r : t) -> inverse (l <+> r) = inverse l <+> inverse r
inverseDistributesOverGroupOp {t} l r =
    let step1 = replace {P = \x => x = neutral} (sym $ groupInverseIsInverseL (l <+> r)) $ the (the t neutral = neutral) Refl in
    let step2 = cong {f = ((inverse r) <+>) . ((inverse l) <+>)} step1 in
    let step3 = replace {P = \x => inverse r <+> (inverse l <+> (l <+> r <+> inverse (l <+> r))) = inverse r <+> x} (monoidNeutralIsNeutralL (inverse l)) step2 in
    let step4 = replace {P = \x => x = inverse r <+> inverse l} (semigroupOpIsAssociative (inverse r) (inverse l) (l <+> r <+> inverse (l <+> r))) step3 in
    let step5 = replace {P = \x => x = inverse r <+> inverse l} (semigroupOpIsAssociative (inverse r <+> inverse l) (l <+> r) (inverse (l <+> r))) step4 in
    let step6 = replace {P = \x => x <+> inverse (l <+> r) = inverse r <+> inverse l} (semigroupOpIsAssociative (inverse r <+> inverse l) l r) step5 in
    let step7 = replace {P = \x => x <+> r <+> inverse (l <+> r) = inverse r <+> inverse l} (sym $ semigroupOpIsAssociative (inverse r) (inverse l) l) step6 in
    let step8 = replace {P = \x => inverse r <+> x <+> r <+> inverse (l <+> r) = inverse r <+> inverse l} (groupInverseIsInverseR l) step7 in
    let step9 = replace {P = \x => x <+> r <+> inverse (l <+> r) = inverse r <+> inverse l} (monoidNeutralIsNeutralL (inverse r)) step8 in
    let step10 = replace {P = \x => x <+> inverse (l <+> r) = inverse r <+> inverse l} (groupInverseIsInverseR r) step9 in
    let step11 = replace {P = \x => x = inverse r <+> inverse l} (monoidNeutralIsNeutralR (inverse (l <+> r))) step10 in
    replace {P = \x => inverse (l <+> r) = x} (abelianGroupOpIsCommutative (inverse r) (inverse l)) step11

multNeutralAbsorbingR : VerifiedRingWithUnity t => (r : t) -> A.neutral <.> r = A.neutral
multNeutralAbsorbingR r =
    let step1 = the (unity <.> r = r) (ringWithUnityIsUnityR r) in
    let step2 = replace {P = \x => x <.> r = r} (sym $ monoidNeutralIsNeutralR unity) step1 in
    let step3 = replace {P = \x => x = r} (ringOpIsDistributiveR neutral unity r) step2 in
    let step4 = replace {P = \x => neutral <.> r <+> x = r} (ringWithUnityIsUnityR r) step3 in
    let step5 = cong {f = \x => x <+> inverse r} step4 in
    let step6 = replace {P = \x => x = r <+> inverse r} (sym $ semigroupOpIsAssociative (neutral <.> r) r (inverse r)) step5 in
    let step7 = replace {P = \x => neutral <.> r <+> x = x} (groupInverseIsInverseL r) step6 in
    replace {P = \x => x = neutral} (monoidNeutralIsNeutralL (neutral <.> r)) step7

multNeutralAbsorbingL : VerifiedRingWithUnity t => (l : t) -> l <.> A.neutral = A.neutral
multNeutralAbsorbingL l =
    let step1 = the (l <.> unity = l) (ringWithUnityIsUnityL l) in
    let step2 = replace {P = \x => l <.> x = l} (sym $ monoidNeutralIsNeutralR unity) step1 in
    let step3 = replace {P = \x => x = l} (ringOpIsDistributiveL l neutral unity) step2 in
    let step4 = replace {P = \x => l <.> neutral <+> x = l} (ringWithUnityIsUnityL l) step3 in
    let step5 = cong {f = \x => x <+> inverse l} step4 in
    let step6 = replace {P = \x => x = l <+> inverse l} (sym $ semigroupOpIsAssociative (l <.> neutral) l (inverse l)) step5 in
    let step7 = replace {P = \x => l <.> neutral <+> x = x} (groupInverseIsInverseL l) step6 in
    replace {P = \x => x = neutral} (monoidNeutralIsNeutralL (l <.> neutral)) step7
