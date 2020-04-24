#include <gtest/gtest.h>

namespace t = ::testing;

class SuccessTest : public t::Test {};

TEST_F(SuccessTest, this_test_should_succeed) { ASSERT_TRUE(1 == 1); }
