//=====================================================================
// Designer : wangziyao1@sjtu.edu.cn
// Revision History
// V0 date:2025/1/8 Initial version, wangziyao1@sjtu.edu.cn
//=====================================================================

#include "mem/cache/replacement_policies/weighted_random_rp.hh"

#include <cassert>
#include <memory>

#include "base/random.hh"
#include "params/WeightedRandomRP.hh"

namespace gem5
{

namespace replacement_policy
{

WeightedRandom::WeightedRandom(const Params &p)
  : Base(p)
{
}

void
WeightedRandom::invalidate(const std::shared_ptr<ReplacementData>& replacement_data)
{
    // Unprioritize replacement data victimization
    std::static_pointer_cast<WeightedRandomReplData>(
        replacement_data)->valid = false;

    std::static_pointer_cast<WeightedRandomReplData>(replacement_data)->weight = 0;
}

void
WeightedRandom::touch(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    std::static_pointer_cast<WeightedRandomReplData>(replacement_data)->weight += 1;
}

void
WeightedRandom::reset(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    // Unprioritize replacement data victimization
    std::static_pointer_cast<WeightedRandomReplData>(
        replacement_data)->valid = true;
    std::static_pointer_cast<WeightedRandomReplData>(replacement_data)->weight = 1;
}

ReplaceableEntry*
WeightedRandom::getVictim(const ReplacementCandidates& candidates) const
{
    // There must be at least one replacement candidate
    assert(candidates.size() > 0);
    ReplaceableEntry* victim = nullptr;
    //------------------------------ weighted random ----------------------------------------
    int totalWeight = 0;
    for (const auto& candidate : candidates) {
        totalWeight += std::static_pointer_cast<WeightedRandomReplData>(
            candidate->replacementData)->weight;
    }
    int randomValue = random_mt.random<int>(0,totalWeight);
    int accumulatedWeight = 0;
    for (const auto& candidate : candidates) {
        accumulatedWeight += std::static_pointer_cast<WeightedRandomReplData>(
            candidate->replacementData)->weight;
        if (accumulatedWeight >= randomValue) {
            victim = candidate;
            break;
        }
    }
    //---------------------------------------------------------------------------------------
    // Choose one candidate at random
    // ReplaceableEntry* victim = candidates[random_mt.random<unsigned>(0,
    //                                 candidates.size() - 1)];

    // Visit all candidates to search for an invalid entry. If one is found,
    // its eviction is prioritized
    for (const auto& candidate : candidates) {
        if (!std::static_pointer_cast<WeightedRandomReplData>(candidate->replacementData)->valid) {
            victim = candidate;
            break;
        }
    }

    return victim;
}

std::shared_ptr<ReplacementData>
WeightedRandom::instantiateEntry()
{
    return std::shared_ptr<ReplacementData>(new WeightedRandomReplData());
}

} // namespace replacement_policy
} // namespace gem5
