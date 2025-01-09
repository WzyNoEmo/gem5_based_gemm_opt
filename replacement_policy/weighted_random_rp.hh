//=====================================================================
// Designer : wangziyao1@sjtu.edu.cn
// Revision History
// V0 date:2025/1/8 Initial version, wangziyao1@sjtu.edu.cn
//=====================================================================

#ifndef __MEM_CACHE_REPLACEMENT_POLICIES_WEIGHTEDRANDOM_RP_HH__
#define __MEM_CACHE_REPLACEMENT_POLICIES_WEIGHTEDRANDOM_RP_HH__

#include "mem/cache/replacement_policies/base.hh"

namespace gem5
{

  struct WeightedRandomRPParams;

namespace replacement_policy
{

class WeightedRandom : public Base
{
  protected:

    struct WeightedRandomReplData : ReplacementData
    {
        /**
         * Flag informing if the replacement data is valid or not.
         * Invalid entries are prioritized to be evicted.
         */
        bool valid;

        int weight;

        /**
         * Default constructor. Invalidate data.
         */
        WeightedRandomReplData() : valid(false),weight(1){}
    };

  public:
    typedef WeightedRandomRPParams Params;
    WeightedRandom(const Params &p);
    ~WeightedRandom() = default;

    /**
     * Invalidate replacement data to set it as the next probable victim.
     * Prioritize replacement data for victimization.
     *
     * @param replacement_data Replacement data to be invalidated.
     */
    void invalidate(const std::shared_ptr<ReplacementData>& replacement_data)
                                                                    override;

    /**
     * Touch an entry to update its replacement data.
     * Does not do anything.
     *
     * @param replacement_data Replacement data to be touched.
     */
    void touch(const std::shared_ptr<ReplacementData>& replacement_data) const
                                                                     override;

    /**
     * Reset replacement data. Used when an entry is inserted.
     * Unprioritize replacement data for victimization.
     *
     * @param replacement_data Replacement data to be reset.
     */
    void reset(const std::shared_ptr<ReplacementData>& replacement_data) const
                                                                     override;

    /**
     * Find replacement victim at random.
     *
     * @param candidates Replacement candidates, selected by indexing policy.
     * @return Replacement entry to be replaced.
     */
    ReplaceableEntry* getVictim(const ReplacementCandidates& candidates) const
                                                                     override;

    /**
     * Instantiate a replacement data entry.
     *
     * @return A shared pointer to the new replacement data.
     */
    std::shared_ptr<ReplacementData> instantiateEntry() override;
};

} // namespace replacement_policy
} // namespace gem5

#endif // __MEM_CACHE_REPLACEMENT_POLICIES_WEIGHTEDRANDOM_RP_HH__
